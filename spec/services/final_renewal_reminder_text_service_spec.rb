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

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration, :with_valid_mobile_phone_number) } }
    end
  end
end
