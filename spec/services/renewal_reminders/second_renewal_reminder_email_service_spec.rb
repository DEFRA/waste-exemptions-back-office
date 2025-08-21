# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe SecondRenewalReminderEmailService do
    describe "run" do

      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration, :site_uses_address) }

      it "sends an email" do
        VCR.use_cassette("second_renewal_reminder_email") do
          expect(run_service).to be_a(Notifications::Client::ResponseNotification)
          expect(run_service.template["id"]).to eq("f308a8a9-0358-41e1-b633-ea4044ad9580")
          # No point checking the registration's renew_token value as VCR caches a random one
          expect(run_service.content["body"]).to match(%r{http://localhost:\d+/renew/})
        end
      end

      it_behaves_like "opted out of renewal reminder"

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:parameters) { { registration: create(:registration) } }
      end
    end
  end
end
