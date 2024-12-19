# frozen_string_literal: true

require "defra_ruby_companies_house"
require_relative "./companies_house_matching_report_service.rb"
# app/services/companies_house_name_matching_service.rb
class CompaniesHouseNameMatchingService < WasteExemptionsEngine::BaseService
  SIMILARITY_THRESHOLD = 0.7
  RATE_LIMIT = 600
  TIME_WINDOW = 300 # 5 minutes in seconds
  RATE_LIMIT_BUFFER = 0.75 # Use only 75% of the rate limit

  def initialize(report_path = nil)
    super()
    @request_count = 0
    @max_requests = (RATE_LIMIT * RATE_LIMIT_BUFFER).to_i
    @unproposed_changes = {}
    @report = CompaniesHouseNameMatchingReportService.new(report_path)
  end

  def run(dry_run: true)
    @dry_run = dry_run

    Rails.logger.info("Starting Companies House name matching process...")
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

    @report.finalize
    Rails.logger.info("Process complete.")
    Rails.logger.info("Report can be accessed at: /company_reports/#{File.basename(@report.report_path)}")

    proposed_changes
  end

  private

  def apply_changes(proposed_changes)
    ActiveRecord::Base.transaction do
      proposed_changes.each_value do |changes|
        changes.each do |reference, _old_name, new_name|
          registration = WasteExemptionsEngine::Registration.find_by(reference: reference)
          registration.update!(operator_name: new_name)
        end
      end
    end
  end

  def fetch_active_registrations
    recently_updated_companies = WasteExemptionsEngine::Company.recently_updated.select(:company_no)

    registrations = WasteExemptionsEngine::Registration
      .joins(:registration_exemptions)
      .where(registration_exemptions: { state: :active })
      .where.not(operator_name: nil)
      .where("company_no IS NOT NULL AND company_no != ''")
      .distinct

    # Keep track of which registrations were skipped due to recent updates
    skipped_registrations = registrations.where(company_no: recently_updated_companies)
    skipped_registrations.each do |reg|
      @report.record_skip(reg, "Company record recently updated")
    end

    registrations.where.not(company_no: recently_updated_companies)
  end

  def group_registrations(registrations)
    registrations.group_by(&:company_no)
  end

  def identify_name_changes(grouped_registrations)
    proposed_changes = {}

    Rails.logger.debug { "Total number of company numbers to process: #{grouped_registrations.size}" }

    sorted_grouped_registrations = grouped_registrations.sort_by { |_, group| -group.size }.first(@max_requests)

    sorted_grouped_registrations.each do |company_no, registrations|
      @report.record_processed
      begin
        companies_house_name = fetch_companies_house_name(company_no)

        unless @dry_run
          company = WasteExemptionsEngine::Company.find_or_create_by_company_no(
            company_no,
            companies_house_name.presence || "Not found"
          )
          company.update(updated_at: Time.current)
        end

        if companies_house_name.blank?
          registrations.each { |reg| @report.record_skip(reg, "No Companies House name found") }
          @report.record_skipped
          next
        end

        compare_name_service = CompareCompanyNameService.new(companies_house_name)

        changes = propose_name_changes(company_no, registrations, companies_house_name, compare_name_service)
        if changes.any?
          proposed_changes[company_no] = changes
          @report.record_updated if !@dry_run
        else
          @report.record_skipped
        end
      rescue StandardError => e
        @report.record_error(company_no, e)
        registrations.each { |reg| @report.record_skip(reg, "Error: #{e.message}") }
        Rails.logger.error("Error processing company #{company_no}: #{e.message}")
      end
    end

    log_unproposed_changes_count
    proposed_changes
  end

  def propose_name_changes(company_no, registrations, companies_house_name, compare_name_service)
    registrations.map do |registration|
      similarity = compare_name_service.compare(registration.operator_name)

      if companies_house_name == registration.operator_name
        @report.record_skip(registration, "Name already matches")
        nil
      elsif similarity >= SIMILARITY_THRESHOLD
        @report.record_change(registration, companies_house_name, similarity)
        [registration.reference, registration.operator_name, companies_house_name]
      else
        @report.record_skip(registration, "Similarity below threshold (#{similarity.round(2)})")
        @unproposed_changes[company_no] ||= []
        @unproposed_changes[company_no] << {
          registration_reference: registration.reference,
          current_name: registration.operator_name,
          companies_house_name: companies_house_name,
          similarity: similarity
        }
        nil
      end
    end.compact
  end

  def fetch_companies_house_name(company_no)
    return nil if @request_count >= @max_requests

    @request_count += 1
    client = DefraRubyCompaniesHouse.new(company_no)
    client.company_name
  rescue StandardError => e
    Rails.logger.error("Failed to fetch company name for #{company_no}: #{e.message}")
    raise # Re-raise to be handled by caller
  end

  def print_summary(proposed_changes, applied: false)
    action = applied ? "applied" : "proposed"

    Rails.logger.info("=== Summary ===")
    Rails.logger.info("Total number of company numbers processed: #{@request_count}")
    Rails.logger.info("Total number of company numbers with #{action} name changes: #{proposed_changes.size}")
    Rails.logger.info("Full report available at: /company_reports/#{File.basename(@report.report_path)}")
    Rails.logger.info("\n#{action.capitalize} name changes:")

    if proposed_changes.empty?
      Rails.logger.info(" No changes #{action}.")
    else
      proposed_changes.each do |company_no, changes|
        Rails.logger.info(" Company number: #{company_no}")
        changes.each do |reference, old_name, new_name|
          puts " Registration reference: #{reference}, Old name: '#{old_name}', New name: '#{new_name}'"
        end
      end
    end
  end

  def print_unproposed_changes
    Rails.logger.debug do
      "\nChanges not proposed - company names too different from Companies House records:"
    end

    if @unproposed_changes.empty?
      Rails.logger.debug " No unproposed changes."
    else
      @unproposed_changes.each do |company_no, details|
        Rails.logger.debug { " Company number: #{company_no}" }
        details.each do |detail|
          Rails.logger.debug { " Registration reference: #{detail[:registration_reference]}" }
          Rails.logger.debug { " Current name: '#{detail[:current_name]}'" }
          Rails.logger.debug { " Companies House name: '#{detail[:companies_house_name]}'" }
          Rails.logger.debug { " Name similarity: #{detail[:similarity].round(2)}" }
          Rails.logger.debug ""
        end
      end
    end
  end

  def log_unproposed_changes_count
    Rails.logger.debug do
      "Total registrations with names too different from Companies House: #{@unproposed_changes.size}"
    end
  end
end
