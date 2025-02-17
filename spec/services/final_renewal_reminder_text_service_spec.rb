# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinalRenewalReminderTextService do
  describe "run" do

    subject(:run_service) { described_class.run(registration: registration) }

    let(:registration) { create(:registration, :with_valid_mobile_phone_number) }
    let(:notifications_client) { instance_double(Notifications::Client) }

    before do
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_sms)
    end

    it "sends a text" do
      run_service

      expect(notifications_client).to have_received(:send_sms)
        .with(hash_including(
                phone_number: registration.contact_phone,
                template_id: "7d101a7d-9678-464e-a57d-e18714afbc5d"
              ))
    end

    context "when registration is a beta participant" do
      before do
        create(:beta_participant, reg_number: registration.reference)
      end

      it "does not send a text message" do
        run_service
        expect(notifications_client).not_to have_received(:send_sms)
      end

      it "creates a communication log for beta participant" do
        run_service
        log = registration.communication_logs.last
        expect(log.message_type).to eq("text")
        expect(log.template_label).to eq("Beta participant - No renewal reminder sent")
        expect(log.sent_to).to eq(registration.contact_phone)
      end
    end

    context "when registration has a nil contact_phone" do
      let(:registration) { create(:registration, contact_phone: nil) }

      it "does not send a text message" do
        run_service
        expect(notifications_client).not_to have_received(:send_sms)
      end
    end

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration, :with_valid_mobile_phone_number) } }
    end
  end
end
