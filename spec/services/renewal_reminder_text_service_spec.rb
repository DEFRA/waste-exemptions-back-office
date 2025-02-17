# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderTextService do
  let(:notifications_client_instance) { instance_double(Notifications::Client) }
  let(:registration) { create(:registration, :with_valid_mobile_phone_number) }
  let(:renewal_reminder_text_service) { described_class.new }

  before do
    allow(Notifications::Client).to receive(:new).and_return(notifications_client_instance)
    allow(notifications_client_instance).to receive(:send_sms).and_return(true)
    allow(renewal_reminder_text_service).to receive(:template).and_return(1)
  end

  describe ".run" do
    context "when registration phone number is not valid mobile number" do
      it "stops when contact_phone is empty" do
        registration.update(contact_phone: nil)
        renewal_reminder_text_service.run(registration: registration)
        expect(notifications_client_instance).not_to have_received(:send_sms)
      end

      it "stops when contact_phone is not valid mobile phone" do
        registration.update(contact_phone: "0123456789")
        renewal_reminder_text_service.run(registration: registration)
        expect(notifications_client_instance).not_to have_received(:send_sms)
      end
    end

    context "when registration phone number is a valid mobile number" do
      it "triggers send_sms on notifications client" do
        renewal_reminder_text_service.run(registration: registration)
        expect(notifications_client_instance).to have_received(:send_sms)
      end
    end

    context "when registration is a beta participant" do
      before do
        create(:beta_participant, reg_number: registration.reference)
      end

      it "does not send a text message" do
        renewal_reminder_text_service.run(registration: registration)
        expect(notifications_client_instance).not_to have_received(:send_sms)
      end

      it "creates a communication log for beta participant" do
        renewal_reminder_text_service.run(registration: registration)
        log = registration.communication_logs.last
        expect(log.message_type).to eq("text")
        expect(log.template_label).to eq("beta_participant")
        expect(log.sent_to).to eq(registration.contact_phone)
      end
    end
  end
end
