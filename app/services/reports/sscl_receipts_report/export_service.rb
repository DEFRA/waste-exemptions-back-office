# frozen_string_literal: true

module Reports
  module SsclReceiptsReport
    class ExportService < WasteExemptionsEngine::BaseService
      include CanLoadFileToAws

      def run
        @date_from = DataSerializer::CHARGING_STARTED_ON
        @date_to = Time.zone.today
        @exported_at = Time.zone.now

        populate_temp_file

        load_file_to_aws_bucket

        record_content_created
      rescue StandardError => e
        Airbrake.notify e, file_name: file_name
        Rails.logger.error "Generate SSCL receipts export csv error for #{file_name}:\n#{e}"
      ensure
        FileUtils.rm_f(file_path)
      end

      private

      def populate_temp_file
        File.write(file_path, sscl_receipts_report)
      end

      def file_path
        Rails.root.join("tmp/#{file_name}")
      end

      def file_name
        "sscl_receipts_#{@exported_at.strftime('%Y-%m-%d_%H%M%S')}.csv"
      end

      def sscl_receipts_report
        DataSerializer.new(date_from: @date_from, date_to: @date_to).to_csv
      end

      def bucket_name
        WasteExemptionsBackOffice::Application.config.finance_data_reports_bucket_name
      end

      def record_content_created
        GeneratedReport.create!(
          file_name: file_name,
          report_type: GeneratedReport::REPORT_TYPE_SSCL_RECEIPTS,
          data_from_date: @date_from,
          data_to_date: @date_to
        )
      end
    end
  end
end
