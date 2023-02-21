# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendDeregistrationEmailJob do
  subject(:job) { described_class.new }

  describe "#perform" do
    let(:registration) { create(:registration) }

    context "when contact_email and applicant_email are identical" do
      before { registration.update!(applicant_email: registration.contact_email) }

      it "sends the email and updates the timestamp on the registration" do
        expect(DeregistrationEmailService)
          .to receive(:run)
          .with(registration: registration, recipient: registration.contact_email)
          .once

        expect(DeregistrationEmailService)
          .not_to receive(:run)
          .with(registration: registration, recipient: registration.applicant_email)

        job.perform(registration.id)

        expect(registration.reload.deregistration_email_sent_at).not_to be_nil
      end
    end

    context "when contact_email and applicant_email are different" do
      it "sends the email and updates the timestamp on the registration" do
        expect(DeregistrationEmailService)
          .to receive(:run)
          .with(registration: registration, recipient: registration.contact_email)
          .once

        expect(DeregistrationEmailService)
          .to receive(:run)
          .with(registration: registration, recipient: registration.applicant_email)
          .once

        job.perform(registration.id)

        expect(registration.reload.deregistration_email_sent_at).not_to be_nil
      end
    end

    context "when sending the email fails" do
      let(:error) { "failure" }

      it "raises the exception and does not update the timestamp on the registration" do
        allow(DeregistrationEmailService).to receive(:run).and_raise(error)

        expect { job.perform(registration.id) }.to raise_exception(error)

        expect(registration.reload.deregistration_email_sent_at).to be_nil
      end
    end

    context "when the email has already been sent" do
      let(:registration) do
        create(:registration, deregistration_email_sent_at: Time.zone.now)
      end

      it "does not re-send the email" do
        expect(DeregistrationEmailService).not_to receive(:run)

        job.perform(registration.id)
      end
    end
  end
end
