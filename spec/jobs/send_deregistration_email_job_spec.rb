# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendDeregistrationEmailJob do

  describe "#perform" do
    subject(:run_job) { described_class.new.perform(registration.id) }

    let(:registration) { create(:registration) }
    let(:notifications_client) { instance_double(Notifications::Client) }
    let(:template_label) { I18n.t("template_labels.deregistration_invitation_email") }

    before do
      allow(DeregistrationEmailService).to receive(:run).with(anything).and_call_original
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email)
    end

    context "when contact_email and applicant_email are identical" do
      before { registration.update!(applicant_email: registration.contact_email) }

      it "sends the email and updates the registration communications log" do
        run_job

        expect(DeregistrationEmailService).to have_received(:run).once
        expect(registration.received_comms?(template_label)).to be true
      end
    end

    context "when contact_email and applicant_email are different" do
      it "sends the email and updates the registration communications log" do

        run_job

        expect(DeregistrationEmailService)
          .to have_received(:run)
          .with(registration: registration, recipient: registration.contact_email)
          .once

        expect(DeregistrationEmailService)
          .to have_received(:run)
          .with(registration: registration, recipient: registration.applicant_email)
          .once

        expect(registration.received_comms?(template_label)).to be true
      end
    end

    context "when sending the email fails" do
      let(:error) { "failure" }

      it "raises the exception and does not update the registration communications log" do
        allow(DeregistrationEmailService).to receive(:run).and_raise(error)

        expect { run_job }.to raise_exception(error)

        expect(registration.received_comms?(template_label)).to be false
      end
    end

    context "when the email has already been sent" do
      before { registration.communication_logs << create(:communication_log, template_label: template_label) }

      it "does not re-send the email" do
        run_job

        expect(DeregistrationEmailService).not_to have_received(:run)
      end
    end
  end
end
