# frozen_string_literal: true

module CompaniesHouseNameMatching
  class RunnerService < WasteExemptionsEngine::BaseService
    def self.run_until_done(dry_run: true, report_path: nil)
      loop do
        result = CompaniesHouseNameMatching::ProcessBatch.run(dry_run: dry_run, report_path: report_path)

        # If we didn't process anything or there's nothing left, we're done.
        break unless result[:any_left_to_process?]

        # Sleep TIME_WINDOW seconds (5 minutes) to respect the rate limit
        sleep(CompaniesHouseNameMatching::ProcessBatch::TIME_BETWEEN_BATCHES)
      end
    end
  end
end
