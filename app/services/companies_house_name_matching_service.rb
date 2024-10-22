# frozen_string_literal: true

require "defra_ruby_companies_house"

# rubocop:disable Metrics/ClassLength
class CompaniesHouseNameMatchingService < WasteExemptionsEngine::BaseService
  SIMILARITY_THRESHOLD = 0.7
  RATE_LIMIT = 600
  TIME_WINDOW = 300 # 5 minutes in seconds
  RATE_LIMIT_BUFFER = 0.75 # Use only 75% of the rate limit

  def initialize
    @request_count = 0
    @max_requests = (RATE_LIMIT * RATE_LIMIT_BUFFER).to_i
    @unproposed_changes = {}
  end

  def run(dry_run: true)
    @dry_run = dry_run
    active_registrations = fetch_active_registrations
    grouped_registrations = group_registrations(active_registrations)
    proposed_changes = identify_name_changes(grouped_registrations)

    if @dry_run
      print_summary(proposed_changes)
      print_unproposed_changes
    else
      apply_changes(proposed_changes)
      print_summary(proposed_changes, applied: true)
    end

    proposed_changes
  end

  private

  def fetch_active_registrations
    WasteExemptionsEngine::Registration.joins(:registration_exemptions)
                                       .where(registration_exemptions: { state: :active })
                                       .where.not(operator_name: nil, company_no: [nil, ""])
                                       .where.not(company_no: WasteExemptionsEngine::Company.recently_updated.select(:company_no))
                                       .distinct
  end

  def group_registrations(registrations)
    registrations.group_by(&:company_no)
  end

  def identify_name_changes(grouped_registrations)
    proposed_changes = {}

    Rails.logger.debug { "Total number of company numbers to process: #{grouped_registrations.size}" }

    sorted_grouped_registrations = grouped_registrations.sort_by { |_, group| -group.size }.first(@max_requests)

    sorted_grouped_registrations.each do |company_no, registrations|
      companies_house_name = fetch_companies_house_name(company_no)
      next unless companies_house_name

      unless @dry_run
        company = WasteExemptionsEngine::Company.find_or_create_by_company_no(company_no, companies_house_name)
        company.update(updated_at: Time.current) #  update the updated_at timestamp
      end

      compare_name_service = CompareCompanyNameService.new(companies_house_name)

      changes = propose_name_changes(company_no, registrations, companies_house_name, compare_name_service)

      proposed_changes[company_no] = changes if changes.any?
    end

    Rails.logger.debug do
      "Total number of registrations where operator name is too different from company name: #{@unproposed_changes.size}"
    end

    proposed_changes
  end

  def propose_name_changes(company_no, registrations, companies_house_name, compare_name_service)
    registrations.map do |registration|
      similarity = compare_name_service.compare(registration.operator_name)
      if companies_house_name == registration.operator_name
        nil
      elsif similarity >= SIMILARITY_THRESHOLD
        [registration.id, registration.operator_name, companies_house_name]
      else
        @unproposed_changes[company_no] ||= []
        @unproposed_changes[company_no] << {
          registration_id: registration.id,
          current_name: registration.operator_name,
          companies_house_name: companies_house_name,
          similarity: similarity
        }
        nil
      end
    end.compact
  end

  def apply_changes(proposed_changes)
    ActiveRecord::Base.transaction do
      proposed_changes.each_value do |changes|
        changes.each do |id, _old_name, new_name|
          registration = WasteExemptionsEngine::Registration.find(id)
          registration.update!(operator_name: new_name)
        end
      end
    end
  end

  def fetch_companies_house_name(company_no)
    return nil if @request_count >= @max_requests

    @request_count += 1
    client = DefraRubyCompaniesHouse.new(company_no)
    client.company_name
  rescue Standarderror => e
    Rails.logger.error("Failed to fetch company name for #{company_no}: #{e.message}")
    nil
  end

  def print_summary(proposed_changes, applied: false)
    action = applied ? "applied" : "proposed"
    Rails.logger.debug { "Total number of company numbers processed: #{@request_count}" }
    Rails.logger.debug { "Total number of company numbers with #{action} name changes: #{proposed_changes.size}" }
    Rails.logger.debug { "\n#{action.capitalize} name changes:" }
    if proposed_changes.empty?
      Rails.logger.debug { "  No changes #{action}." }
    else
      proposed_changes.each do |company_no, changes|
        Rails.logger.debug { "  Company number: #{company_no}" }
        changes.each do |id, old_name, new_name|
          puts "    Registration ID: #{id}, Old name: '#{old_name}', New name: '#{new_name}'"
        end
      end
    end
  end

  def print_unproposed_changes
    Rails.logger.debug "\nCompany numbers for which changes were not proposed as companies name is too different from operator name:"
    if @unproposed_changes.empty?
      Rails.logger.debug "  No unproposed changes."
    else
      @unproposed_changes.each do |company_no, details|
        Rails.logger.debug { "  Company number: #{company_no}" }
        details.each do |detail|
          Rails.logger.debug { "    Registration ID: #{detail[:registration_id]}" }
          Rails.logger.debug { "    Current name: '#{detail[:current_name]}'" }
          Rails.logger.debug { "    Companies House name: '#{detail[:companies_house_name]}'" }
          Rails.logger.debug { "    Name similarity: #{detail[:similarity].round(2)}" }
          Rails.logger.debug ""
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
