# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bulk Exports" do
  let(:user) { create(:user, :admin_team_user) }

  before do
    sign_in(user)
  end

  describe "GET /data-exports" do
    context "when bulk data report is present" do
      before do
        create(:generated_report, created_at: Time.zone.local(2019, 6, 1, 12, 0), data_from_date: Date.new(2019, 6, 1))
      end

      it "renders the correct template, the timestamp in an accessible format and responds with a 200 status code" do
        # The 2 in "12:00pm" is optional to allow for changes in daylight savings - 12:00pm or 1:00pm is valid
        export_at_regex = /These files were created at 12?:00pm on 1 June 2019\./m

        get bulk_exports_path

        expect(response).to render_template("bulk_exports/show")
        expect(response.body.scan(export_at_regex).count).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when finance_data data report is present" do
      before do
        create(:generated_report, :finance_data, file_name: "finance_data_report.csv")
      end

      it "renders the correct template, the report link is present and responds with a 200 status code" do
        get bulk_exports_path

        expect(response).to render_template("bulk_exports/show")
        expect(response.body).to include("finance_data_report.csv")
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /data-exports/:id" do
    let(:generated_report) { create(:generated_report) }
    let(:bucket_name) { WasteExemptionsBackOffice::Application.config.bulk_reports_bucket_name }
    let(:download_link) do
      bucket = DefraRuby::Aws.get_bucket(bucket_name)
      bucket.presigned_url(generated_report.file_name)
    end

    it "redirects to the correct URL and responds with a 302 status code" do
      get bulk_export_download_path(generated_report)

      expect(response).to redirect_to(download_link)
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET /data-exports/download_history.csv" do
    let(:csv_content) { "Report,Name,Email,Downloaded at\nmonthly,report.csv,test@example.com,01/01/2023 12:00" }
    let(:service) { instance_double(Reports::DownloadHistoryExportService, run: csv_content) }

    before do
      allow(Reports::DownloadHistoryExportService).to receive(:new).and_return(service)
    end

    it "responds with success" do
      get bulk_export_download_history_path, params: { format: :csv }
      expect(response).to have_http_status(:success)
    end

    it "calls the DownloadHistoryExportService" do
      get bulk_export_download_history_path, params: { format: :csv }
      expect(Reports::DownloadHistoryExportService).to have_received(:new)
      expect(service).to have_received(:run)
    end

    it "returns the correct CSV content" do
      get bulk_export_download_history_path, params: { format: :csv }
      expect(response.body).to eq(csv_content)
      expect(response.header["Content-Type"]).to include("text/csv")
    end
  end
end
