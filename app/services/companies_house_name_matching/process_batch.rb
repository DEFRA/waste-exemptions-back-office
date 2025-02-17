# frozen_string_literal: true

module CompaniesHouseNameMatching
  class ProcessBatch < WasteExemptionsEngine::BaseService
    include Logging

    RATE_LIMIT = 600
    TIME_BETWEEN_BATCHES = 300 # 5 minutes in seconds
    RATE_LIMIT_BUFFER = 0.75

    def initialize
      super
      @max_requests = (RATE_LIMIT * RATE_LIMIT_BUFFER).to_i
      @unproposed_changes = {}
    end

    def run(dry_run: true, report_path: nil)
      @dry_run = dry_run
      @report = ReportService.new(report_path)
      with_stdout_logger do
        process_batch
      end
    end

    private

    def process_batch
      active_registrations = fetch_active_registrations
      return handle_empty_batch if active_registrations.none?

      log_batch_info(active_registrations)
      grouped_registrations = active_registrations.group_by(&:company_no)

      proposed_changes = ProcessRegistrations.run(report_service: @report,
                                                  dry_run: @dry_run,
                                                  grouped_registrations: grouped_registrations,
                                                  max_requests: @max_requests)
      handle_changes(proposed_changes)
      remaining = fetch_active_registrations.count
      build_result(proposed_changes, remaining)
    end

    def handle_empty_batch
      {
        processed_company_count: 0,
        skipped_company_count: 0,
        total_left_to_process: 0,
        any_left_to_process?: false
      }
    end

    def handle_changes(proposed_changes)
      if @dry_run
        log_summary(proposed_changes)
        log_unproposed_changes
      else
        ApplyChanges.run(proposed_changes)
        log_summary(proposed_changes, applied: true)
      end
      @report.finalize
      log_completion
    end

    def build_result(proposed_changes, remaining)
      {
        processed_company_count: proposed_changes.size,
        skipped_company_count: @unproposed_changes.size,
        total_left_to_process: remaining,
        any_left_to_process?: remaining.positive?
      }
    end

    def fetch_active_registrations
      FetchData.fetch_active_registrations
    end

    def with_stdout_logger
      original_logger = Rails.logger
      Rails.logger = Logger.new($stdout)
      yield
    ensure
      Rails.logger = original_logger
    end
  end
end
