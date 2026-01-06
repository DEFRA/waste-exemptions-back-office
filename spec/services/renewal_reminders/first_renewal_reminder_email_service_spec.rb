# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe FirstRenewalReminderEmailService do
    describe "run" do

      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration) }

      shared_examples "sends an email with the correct template id" do
        it do
          VCR.use_cassette(cassette_name) do
            result = run_service

            expect(result).to be_a(Notifications::Client::ResponseNotification)
            expect(result.template["id"]).to eq(template_id)
            # No point checking the registration's renew_token value as VCR caches a random one
            expect(result.content["body"]).to match(%r{http://localhost:\d+/renew/}) unless registration.is_legacy_bulk
          end
        end
      end

      context "when the registration is not legacy bulk" do
        before { registration.update(is_legacy_bulk: false) }

        it_behaves_like "sends a Notify message with the correct template id and with a renewal link" do
          let(:cassette_name) { "first_renewal_reminder_email" }
          let(:template_id) { "b1c9cda2-b502-4667-b22c-63e8725f7a27" }
        end
      end

      context "when the registration is legacy bulk" do
        before { registration.update(is_legacy_bulk: true) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "first_renewal_reminder_email_LB" }
          let(:template_id) { "69a8254e-2bd0-4e09-b27a-ad7e8a29d783" }
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
