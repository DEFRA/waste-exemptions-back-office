# frozen_string_literal: true

module CompaniesHouseNameMatching
  class ReportService
    attr_reader :report_path, :summary_path

    delegate :record_change, :record_skip, :record_error, to: :@report

    def initialize(report_path = nil)
      @report_path = parse_report_path(report_path)
      @summary_path = @report_path.sub(".csv", "_summary.csv")
      @report = CsvReportWriter.new(@report_path)
      initialize_counters
      log_report_path
    end

    def record_processed
      @processed_count += 1
    end

    def record_updated
      @updated_count += 1
    end

    def record_skipped
      @skipped_count += 1
    end

    def finalize
      if File.exist?(summary_path)
        append_summary_report
      else
        create_summary_report
      end
    end

    private

    def initialize_counters
      @processed_count = 0
      @updated_count = 0
      @skipped_count = 0
      @started_at = Time.current
    end

    def create_summary_report
      CSV.open(summary_path, "w") do |csv|
        csv << [
          "Batch #",
          "Started at",
          "Completed at",
          "Processed",
          "Updated",
          "Skipped"
        ]
        csv << [
          next_batch_number,
          @started_at,
          Time.current,
          @processed_count,
          @updated_count,
          @skipped_count
        ]
      end
    end

    def append_summary_report
      CSV.open(summary_path, "ab") do |csv|
        csv << [
          next_batch_number,
          @started_at,
          Time.current,
          @processed_count,
          @updated_count,
          @skipped_count
        ]
      end
    end

    def next_batch_number
      return 1 unless File.exist?(summary_path)

      CSV.read(summary_path).size + 1
    end

    def parse_report_path(report_path)
      if report_path.present?
        Rails.public_path.join("company_reports", report_path)
      else
        default_report_path
      end
    end

    def default_report_path
      date = Time.current.strftime("%Y%m%d")
      Rails.public_path.join("company_reports", "companies_house_update_#{date}.csv")
    end

    def log_report_path
      relative_path = report_path.to_s.sub(Rails.public_path.to_s, "")
      Rails.logger.info { "Report will be generated at: #{relative_path}" }
    end
  end
end
