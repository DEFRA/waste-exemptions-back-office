# frozen_string_literal: true

class BulkExportsController < ApplicationController
  def show
    authorize! :read, Reports::GeneratedReport

    @finance_data_exports = FinanceDataExportsPresenter.new
  end

  def download
    authorize! :read, Reports::GeneratedReport

    generated_report = Reports::GeneratedReport.find(params[:id])
    bucket_name = bucket_name_for_report(generated_report)

    bucket = DefraRuby::Aws.get_bucket(bucket_name)
    url = bucket.presigned_url(generated_report.file_name)

    # track the download
    Reports::TrackDownloadService.run(report: generated_report, user: current_user)

    redirect_to url, allow_other_host: true
  end

  def download_history
    authorize! :read, Reports::Download

    respond_to do |format|
      format.csv do
        timestamp = Time.zone.now.strftime("%Y-%m-%d_%H:%M")
        send_data Reports::DownloadHistoryExportService.run, filename: "download_history_#{timestamp}.csv"
      end
    end
  end

  private

  def bucket_name_for_report(generated_report)
    case generated_report.report_type
    when "bulk"
      WasteExemptionsBackOffice::Application.config.bulk_reports_bucket_name
    when "finance_data"
      WasteExemptionsBackOffice::Application.config.finance_data_reports_bucket_name
    else
      raise "Unknown report type: #{generated_report.report_type}"
    end
  end
end
