# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bulk Exports" do
  let(:user) { create(:user, :admin_team_user) }

  before do
    sign_in(user)
  end

  shared_examples "renders the correct template and returns correct status" do
    it "renders the correct template" do
      get data_exports_path
      expect(response).to render_template("data_exports/show")
    end

    it "responds with a 200 status code" do
      get data_exports_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /data-exports" do
    context "when user has no permission to access reports" do
      let(:user) { create(:user, :finance_user) }

      it "responds with a 302 status code" do
        get data_exports_path
        expect(response).to have_http_status(:found)
      end

      it "redirects to the permission page" do
        get data_exports_path
        expect(response).to redirect_to("/pages/permission")
      end
    end

    context "when boxi data report is present" do
      before do
        create(:generated_report, :boxi, file_name: "boxi_report.csv")
      end

      context "when user has permission to download boxi report" do
        let(:user) { create(:user, :admin_team_lead) }

        it_behaves_like "renders the correct template and returns correct status"

        it "contains boxi report link" do
          get data_exports_path
          expect(response.body).to include("boxi_report.csv")
        end
      end
    end

    context "when bulk data report is present" do
      before do
        create(:generated_report, :bulk, file_name: "20230601-20230630.csv",
                                         data_from_date: Date.new(2023, 6, 1))
      end

      context "when user has permission to download bulk report" do
        let(:user) { create(:user, :admin_team_lead) }

        it_behaves_like "renders the correct template and returns correct status"

        it "contains bulk report link" do
          get data_exports_path
          expect(response.body).to include("June 2023")
        end
      end
    end

    context "when finance_data data report is present" do
      before do
        create(:generated_report, :finance_data, file_name: "finance_data_report.csv")
      end

      context "when user has permission to download finance data report" do
        let(:user) { create(:user, :admin_team_lead) }

        it_behaves_like "renders the correct template and returns correct status"

        it "contains finance_data report link" do
          get data_exports_path
          expect(response.body).to include("finance_data_report.csv")
        end
      end

      context "when user has no permission to download finance data report" do

        it_behaves_like "renders the correct template and returns correct status"

        it "does not contain finance_data report link" do
          get data_exports_path
          expect(response.body).not_to include("finance_data_report.csv")
        end
      end
    end
  end

  describe "GET /data-exports/:id" do
    let(:generated_report) { create(:generated_report) }
    let(:bucket_name) { WasteExemptionsBackOffice::Application.config.finance_data_reports_bucket_name }
    let(:download_link) do
      bucket = DefraRuby::Aws.get_bucket(bucket_name)
      bucket.presigned_url(generated_report.file_name)
    end

    it "redirects to the correct URL and responds with a 302 status code" do
      get data_export_download_path(generated_report)

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
      get data_export_download_history_path, params: { format: :csv }
      expect(response).to have_http_status(:success)
    end

    it "calls the DownloadHistoryExportService" do
      get data_export_download_history_path, params: { format: :csv }
      expect(Reports::DownloadHistoryExportService).to have_received(:new)
      expect(service).to have_received(:run)
    end

    it "returns the correct CSV content" do
      get data_export_download_history_path, params: { format: :csv }
      expect(response.body).to eq(csv_content)
      expect(response.header["Content-Type"]).to include("text/csv")
    end
  end
end
