# frozen_string_literal: true

require "csv"

module Reports
  class DownloadHistoryExportService < WasteExemptionsEngine::BaseService

    COLUMNS = {
      report_type: "Report",
      file_name: "Name",
      email: "Email",
      downloaded_at: "Downloaded at"
    }.freeze

    def run
      CSV.generate do |csv|
        csv << COLUMNS.values
        history_scope.each do |download|
          csv << present_row(download)
        end
      end
    end

    private

    def history_scope
      Reports::Download.order(downloaded_at: :desc)
    end

    def report_name(report_type)
      type = report_type.gsub(/([a-z])([A-Z])/, '\1_\2').downcase.gsub("::", ".")
      I18n.t("data_exports.#{type}")
    end

    def present_row(download)
      [
        report_name(download.report_type),
        download.report_file_name,
        User.find(download.user_id)&.email,
        download.downloaded_at&.strftime(Time::DATE_FORMATS[:day_month_year_time_slashes])
      ]
    end
  end
end
