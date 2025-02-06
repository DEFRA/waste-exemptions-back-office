# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe ExportService do
      describe ".run" do
        before { allow(Airbrake).to receive(:notify) }

        context "when the request succeed" do
          it "generates a CSV file containing finance data records, upload it to AWS and record the upload" do
            stub_successful_request

            expect { described_class.run }.to change(GeneratedReport, :count).by(1)

            expect(GeneratedReport.last.file_name).to eq("charging_payment_data_#{Time.zone.today.strftime('%Y-%m-%d')}.csv")
            expect(GeneratedReport.last.data_from_date.to_fs(:day_month_year_slashes)).to eq("01/02/2025")
            expect(GeneratedReport.last.data_to_date.to_fs(:day_month_year_slashes)).to eq(Time.zone.today.to_fs(:day_month_year_slashes))

            # Expect no error gets notified
            expect(Airbrake).not_to have_received(:notify)
          end
        end

        context "when the request fails" do
          it "fails gracefully and report the error" do
            stub_failing_request

            described_class.run

            # Expect an error to get notified
            expect(Airbrake).to have_received(:notify).once
          end
        end
      end

      def stub_successful_request
        stub_request(:put, %r{https://.*\.s3\.eu-west-1\.amazonaws\.com/charging_payment_data_#{Time.zone.today.to_fs(:year_month_day)}\.csv.*})
      end

      def stub_failing_request
        stub_request(
          :put,
          %r{https://.*\.s3\.eu-west-1\.amazonaws\.com/charging_payment_data_#{Time.zone.today.to_fs(:year_month_day)}\.csv.*}
        ).to_return(
          status: 403
        )
      end
    end
  end
end
