# frozen_string_literal: true

require_relative "../../concerns/can_load_file_to_aws"

module Reports
  module FinanceDataReport
    class ExportService < WasteExemptionsEngine::BaseService
      include CanLoadFileToAws

      def run
        # the date when payments related functionality was released and made live
        @date_from = "2025-02-01"
        @date_to = Time.zone.today

        populate_temp_file

        load_file_to_aws_bucket

        record_content_created
      rescue StandardError => e
        Airbrake.notify e, file_name: file_name
        Rails.logger.error "Generate finance data export csv error for #{file_name}:\n#{e}"
      ensure
        File.unlink(file_path)
      end

      private

      def populate_temp_file
        File.write(file_path, finance_data_report)
      end

      def file_path
        Rails.root.join("tmp/#{file_name}")
      end

      def file_name
        "charging_payment_data_#{@date_to.strftime('%Y-%m-%d')}.csv"
      end

      def finance_data_report
        FinanceDataReport::DataSerializer.new.to_csv
      end

      def bucket_name
        WasteExemptionsBackOffice::Application.config.bulk_reports_bucket_name
      end

      def record_content_created
        GeneratedReport.create!(
          file_name: file_name,
          report_type: GeneratedReport::REPORT_TYPE_FINANCE_DATA,
          data_from_date: @date_from,
          data_to_date: @date_to
        )
      end
    end
  end
end
