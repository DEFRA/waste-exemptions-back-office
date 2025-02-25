# frozen_string_literal: true

module CompaniesHouseNameMatching
  class ProcessRegistrations < WasteExemptionsEngine::BaseService
    SIMILARITY_THRESHOLD = 0.7

    def run(report_service:, dry_run:, grouped_registrations:, max_requests:)
      @report = report_service
      @dry_run = dry_run
      @unproposed_changes = {}

      proposed_changes = {}
      sorted_groups = sort_and_limit_groups(grouped_registrations, max_requests)
      sorted_groups.each do |company_no, registrations|
        process_company_group(company_no, registrations, proposed_changes)
      end
      proposed_changes
    end

    private

    def sort_and_limit_groups(grouped_registrations, max_requests)
      grouped_registrations.sort_by { |_, group| -group.size }.first(max_requests)
    end

    def process_company_group(company_no, registrations, proposed_changes)
      @report.record_processed
      companies_house_name = FetchData.fetch_companies_house_name(company_no)
      handle_company_record(company_no, companies_house_name) unless @dry_run

      if companies_house_name.blank?
        handle_missing_name(registrations)
        return
      end

      changes = propose_name_changes(company_no, registrations, companies_house_name)
      handle_changes(changes, company_no, proposed_changes)
    rescue StandardError => e
      handle_error(company_no, registrations, e)
    end

    def propose_name_changes(company_no, registrations, companies_house_name)
      registrations.map do |registration|
        similarity = CompareCompanyNames.run(companies_house_name:,
                                             other_company_name: registration.operator_name)

        if companies_house_name == registration.operator_name
          @report.record_skip(registration, "Name already matches", companies_house_name:, similarity:)
          nil
        elsif similarity >= SIMILARITY_THRESHOLD
          @report.record_change(registration, companies_house_name, similarity)
          [registration.reference, registration.operator_name, companies_house_name]
        else
          @report.record_skip(registration, "Similarity below threshold", companies_house_name:, similarity:)
          record_unproposed_change(company_no, registration, companies_house_name, similarity)
          nil
        end
      end.compact
    end

    def record_unproposed_change(company_no, registration, companies_house_name, similarity)
      @unproposed_changes[company_no] ||= []
      @unproposed_changes[company_no] << {
        registration_reference: registration.reference,
        current_name: registration.operator_name,
        companies_house_name: companies_house_name,
        similarity: similarity
      }
    end

    def handle_company_record(company_no, companies_house_name)
      company = WasteExemptionsEngine::Company.find_or_create_by_company_no(
        company_no,
        companies_house_name.presence || "Not found"
      )
      company.update(updated_at: Time.current)
    end

    def handle_missing_name(registrations)
      registrations.each { |reg| @report.record_skip(reg, "No Companies House name found") }
      @report.record_skipped
    end

    def handle_changes(changes, company_no, proposed_changes)
      if changes.any?
        proposed_changes[company_no] = changes
        @report.record_updated unless @dry_run
      else
        @report.record_skipped
      end
    end

    def handle_error(company_no, registrations, error)
      @report.record_error(company_no, error)
      registrations.each { |reg| @report.record_skip(reg, "Error: #{error.message}") }
      Rails.logger.error("Error processing company #{company_no}: #{error.message}")
    end
  end
end
