# frozen_string_literal: true

require "defra_ruby/companies_house"

class CompaniesHouseNameMatchingBatchService < WasteExemptionsEngine::BaseService
  SIMILARITY_THRESHOLD = 0.7
  RATE_LIMIT = 600
  TIME_WINDOW = 300 # 5 minutes in seconds
  RATE_LIMIT_BUFFER = 0.75

  def initialize
    super()
    @request_count = 0
    @max_requests = (RATE_LIMIT * RATE_LIMIT_BUFFER).to_i
    @unproposed_changes = {}
  end

  def run(dry_run: true, report_path: nil)
    @dry_run = dry_run
    @report = CompaniesHouseNameMatchingReportService.new(report_path)

    puts("Starting a single batch of Companies House name matching...")

    # 1) Fetch the registrations that are eligible to be processed this batch
    active_registrations = fetch_active_registrations

    if active_registrations.none?
      puts "No registrations left to process (they are all recently updated or do not exist)."
      return {
        processed_company_count: 0,
        skipped_company_count: 0,
        total_left_to_process: 0,
        any_left_to_process?: false
      }
    end

    puts "Total number of registrations in state active overall: #{WasteExemptionsEngine::Registration.joins(:registration_exemptions).where(registration_exemptions: { state: :active }).count}"
    puts "Number of active registrations to process in this batch (not recently updated): #{active_registrations.size}"
    puts "Total number of recently updated companies: #{WasteExemptionsEngine::Company.recently_updated.count}"

    # 2) Group and limit by max_requests
    grouped_registrations = active_registrations.group_by(&:company_no)
    proposed_changes = identify_name_changes(grouped_registrations)

    # 3) Either just report the changes or apply them
    if @dry_run
      print_summary(proposed_changes)
      print_unproposed_changes
    else
      apply_changes(proposed_changes)
      print_summary(proposed_changes, applied: true)
    end

    @report.finalize
    puts("Batch complete.")
    puts("Report can be accessed at: /company_reports/#{File.basename(@report.report_path)}")

    # 4) Figure out how many *total* registrations remain for the next batch.
    #    This will do another query to see if there are more left to do.
    remaining = fetch_active_registrations.count
    puts "Total number of registrations left to process: #{remaining}"

    {
      processed_company_count: proposed_changes.size,
      skipped_company_count: @unproposed_changes.size,
      total_left_to_process: remaining,
      any_left_to_process?: (remaining > 0)
    }
  end

  private

  # The rest of the methods are basically the same as in your original
  # CompaniesHouseNameMatchingService, but only focusing on a *single batch*.

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
      .where.not(company_no: recently_updated_companies) # Exclude any registration whose company_no is "recently updated"
      .distinct
  end

  def identify_name_changes(grouped_registrations)
    proposed_changes = {}

    puts "Total number of company numbers to process in this batch: #{grouped_registrations.size}"

    # Sort by group size and only pick the number of groups allowed by
    # @max_requests
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
          @report.record_updated unless @dry_run
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
    puts "running fetch_companies_house_name for company_no: #{company_no}"
    puts "making get request to #{}"
    companies_house_api = DefraRuby::CompaniesHouse::API.new
    puts "making get request to #{companies_house_api.send(:companies_house_endpoint)}"
    puts "api_key: #{companies_house_api.send(:api_key)}"
    companies_house_details = companies_house_api.run(company_number: company_no)
    companies_house_details[:company_name]
    puts "companies_house_details: #{companies_house_details}"
  rescue StandardError => e
    Rails.logger.error("Failed to fetch company name for #{company_no}: #{e.message}")
    raise
  end

  def print_summary(proposed_changes, applied: false)
    action = applied ? "applied" : "proposed"

    puts("=== Summary ===")
    puts("Total number of company numbers processed this batch: #{@request_count}")
    puts("Total number of company numbers with #{action} name changes: #{proposed_changes.size}")
    puts("Full report available at: /company_reports/#{File.basename(@report.report_path)}")
    puts("\n#{action.capitalize} name changes:")

    if proposed_changes.empty?
      puts(" No changes #{action}.")
    else
      proposed_changes.each do |company_no, changes|
        puts(" Company number: #{company_no}")
        changes.each do |reference, old_name, new_name|
          puts "   Registration reference: #{reference}, Old name: '#{old_name}', New name: '#{new_name}'"
        end
      end
    end
  end

  def print_unproposed_changes
    puts "\nChanges not proposed (too different from Companies House records):"
    if @unproposed_changes.empty?
      puts " No unproposed changes."
    else
      @unproposed_changes.each do |company_no, details|
        puts " Company number: #{company_no}"
        details.each do |detail|
          puts "   Registration reference: #{detail[:registration_reference]}"
          puts "   Current name: '#{detail[:current_name]}'"
          puts "   Companies House name: '#{detail[:companies_house_name]}'"
          puts "   Name similarity: #{detail[:similarity].round(2)}"
          puts ""
        end
      end
    end
  end

  def log_unproposed_changes_count
    puts "Total registrations with names too different from Companies House: #{@unproposed_changes.size}"
  end
end
