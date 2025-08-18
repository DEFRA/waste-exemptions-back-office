# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe SecondRenewalReminderEmailService do
    describe "run" do
      let(:registration) { create(:registration, :site_uses_address) }
      let(:run_service) { described_class.run(registration: registration) }

      # rubocop:disable Rails/SkipsModelValidations
      before { registration.update_column(:unsubscribe_token, nil) }
      # rubocop:enable Rails/SkipsModelValidations

      it "sends an email" do
        VCR.use_cassette("second_renewal_reminder_email") do

          response = run_service

          expect(response).to be_a(Notifications::Client::ResponseNotification)
          expect(response.template["id"]).to eq("80585fc6-9c65-4909-8cb4-6888fa4427c8")
          expect(response.content["subject"]).to eq("Renew your waste exemptions online now")
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
