# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe EprExportService do
    describe ".run" do

      before { allow(Airbrake).to receive(:notify) }

      context "when the AWS request succeeds" do
        it "generates a CSV file containing all active exemptions and uploads it to AWS" do
          create_list(:registration_exemption, 2, :with_registration, :active)
          file_name = "waste_exemptions_epr_daily_full"

          stub_request(:put, %r{https://.*\.s3\.eu-west-1\.amazonaws\.com/EPR/#{file_name}\.csv.*})

          described_class.run

          # Expect no error gets notified
          expect(Airbrake).not_to have_received(:notify)
        end
      end

      context "when the request fails" do
        it "fails gracefully and reports the error" do
          create(:registration_exemption, :with_registration, :active)

          file_name = "waste_exemptions_epr_daily_full"

          stub_request(
            :put,
            %r{https://.*\.s3\.eu-west-1\.amazonaws\.com/EPR/#{file_name}\.csv.*}
          ).to_return(status: 403)

          described_class.run

          # Expect an error to get notified
          expect(Airbrake).to have_received(:notify).once
        end
      end
    end
  end
end
