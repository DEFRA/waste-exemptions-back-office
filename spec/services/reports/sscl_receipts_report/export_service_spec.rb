# frozen_string_literal: true

require "rails_helper"

module Reports
  module SsclReceiptsReport
    RSpec.describe ExportService do
      describe ".run" do
        before do
          travel_to(Time.zone.local(2026, 5, 26, 10, 30, 15))
          allow(Airbrake).to receive(:notify)
        end

        context "when the request succeeds" do
          before do
            stub_successful_request
          end

          it "creates a GeneratedReport record with correct details" do
            expect { described_class.run }.to change(GeneratedReport, :count).by(1)

            generated_report = GeneratedReport.last
            expect(generated_report.file_name).to eq("sscl_receipts_2026-05-26_103015.csv")
            expect(generated_report.report_type).to eq(GeneratedReport::REPORT_TYPE_SSCL_RECEIPTS)
            expect(generated_report.data_from_date.to_fs(:day_month_year_slashes)).to eq("01/02/2025")
            expect(generated_report.data_to_date.to_fs(:day_month_year_slashes)).to eq("26/05/2026")
          end

          it "does not notify Airbrake" do
            described_class.run

            expect(Airbrake).not_to have_received(:notify)
          end
        end

        context "when the request fails" do
          it "fails gracefully and reports the error" do
            stub_failing_request

            described_class.run

            expect(Airbrake).to have_received(:notify).once
          end
        end
      end

      def stub_successful_request
        stub_request(:put, %r{https://.*\.s3\.eu-west-1\.amazonaws\.com/sscl_receipts_2026-05-26_103015\.csv.*})
      end

      def stub_failing_request
        stub_request(
          :put,
          %r{https://.*\.s3\.eu-west-1\.amazonaws\.com/sscl_receipts_2026-05-26_103015\.csv.*}
        ).to_return(
          status: 403
        )
      end
    end
  end
end
