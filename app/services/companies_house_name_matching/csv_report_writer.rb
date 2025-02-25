# frozen_string_literal: true

module CompaniesHouseNameMatching
  class CsvReportWriter
    attr_reader :report_path

    def initialize(report_path)
      @report_path = report_path
      ensure_report_directory
      initialize_csv unless File.exist?(@report_path)
    end

    def record_change(registration, companies_house_name, similarity = nil)
      CSV.open(report_path, "a") do |csv|
        csv << [
          registration.reference,
          registration.company_no,
          registration.operator_name,
          companies_house_name,
          similarity&.round(2),
          "CHANGE"
        ]
      end
    end

    def record_skip(registration, reason, companies_house_name: nil, similarity: nil)
      CSV.open(report_path, "a") do |csv|
        csv << [
          registration.reference,
          registration.company_no,
          registration.operator_name,
          companies_house_name,
          similarity&.round(2),
          "SKIP: #{reason}"
        ]
      end
    end

    def record_error(company_no, error)
      CSV.open(report_path, "a") do |csv|
        csv << [
          nil,
          company_no,
          nil,
          nil,
          nil,
          "ERROR: #{error.message}"
        ]
      end
    end

    private

    def ensure_report_directory
      directory = File.dirname(report_path)
      Rails.logger.info { "Ensuring report directory exists at: #{directory}" }
      FileUtils.mkdir_p(directory)
    end

    def initialize_csv
      Rails.logger.info { "Creating new report at: #{@report_path}" }
      CSV.open(report_path, "w") do |csv|
        csv << ["Companies House Name Matching Report"]
        csv << ["Started at", Time.current]
        csv << []
        csv << ["Registration Ref", "Company Number", "Current Name", "Companies House Name", "Similarity Score",
                "Status"]
      end
    end
  end
end
