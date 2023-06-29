# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe DeregistrationEmailBatchExportService do
    describe ".run" do
      let(:bucket) { instance_double(DefraRuby::Aws::Bucket) }
      let(:aws_response) { instance_double(DefraRuby::Aws::Response, successful?: true) }
      let(:bucket_name) { "buck-it" }
      let(:file_name) { "foo" }
      let(:registration) { create(:registration, :eligible_for_deregistration) }

      subject(:service) { described_class.new }

      around do |example|
        old_bucket_name = Rails.configuration.deregistration_email_bucket_name
        Rails.configuration.deregistration_email_bucket_name = "foo"
        example.run
      ensure
        Rails.configuration.deregistration_email_bucket_name = old_bucket_name
      end

      before do
        allow(Airbrake).to receive(:notify)
        allow(service).to receive(:file_name).and_return("foo")
        allow(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)

        registration
      end

      context "when succesful" do
        before do
          allow(bucket).to receive(:load).and_return(aws_response)
        end

        it "generates a CSV file containing all active exemptions and uploads it to AWS" do
          expect(service.run(batch_size: 1)).to be(true)

          expect(registration.received_comms?(I18n.t("template_labels.deregistration_invitation_email"))).to be true

          expect(bucket).to have_received(:load)

          # Expect no error gets notified
          expect(Airbrake).not_to have_received(:notify)
        end
      end

      context "when failed" do
        let(:error) { StandardError.new("foo") }

        before do
          allow(bucket).to receive(:load).and_raise(error)
        end

        it "notifies the error received" do
          service.run(batch_size: 1)

          expect(Airbrake).to have_received(:notify).with(error, file_name: "foo")
        end
      end
    end
  end
end
