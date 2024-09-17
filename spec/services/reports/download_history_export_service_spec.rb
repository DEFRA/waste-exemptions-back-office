# frozen_string_literal: true

require "rails_helper"
require "csv"

module Reports
  RSpec.describe DownloadHistoryExportService do
    describe ".run" do
      let!(:user) { create(:user, email: "test@example.com") }
      let!(:report) { create(:generated_report) }
      let!(:download) { create(:download, report_type: report.class.name, report_file_name: report.file_name, user_id: user.id, downloaded_at: Time.zone.now) }
      let(:service) { described_class.new }

      it "generates a CSV with the correct headers and data" do
        csv_content = service.run
        csv = CSV.parse(csv_content, headers: true)

        expect(csv.headers).to eq(["Report", "Name", "Email", "Downloaded at"])
        expect(csv[0]["Report"]).to eq("Registration Data Export")
        expect(csv[0]["Name"]).to eq(download.report_file_name)
        expect(csv[0]["Email"]).to eq(user.email)
        expect(csv[0]["Downloaded at"]).to eq(download.downloaded_at.strftime(Time::DATE_FORMATS[:day_month_year_time_slashes]))
      end
    end
  end
end
