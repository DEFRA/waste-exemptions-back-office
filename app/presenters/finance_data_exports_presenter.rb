# frozen_string_literal: true

class FinanceDataExportsPresenter

  def links
    @_links ||= generated_reports_scope.map do |generated_report|
      build_link_data(generated_report)
    end
  end

  private

  def build_link_data(generated_report)
    {
      id: generated_report.id,
      url: bucket.presigned_url(generated_report.file_name),
      text: generated_report.file_name
    }
  end

  def export_executed_at
    @_export_executed_at ||= generated_reports_scope.first&.created_at
  end

  def generated_reports_scope
    Reports::GeneratedReport.finance_data.order(:created_at)
  end

  def bucket
    DefraRuby::Aws.get_bucket(bucket_name)
  end

  def bucket_name
    WasteExemptionsBackOffice::Application.config.bulk_reports_bucket_name
  end
end
