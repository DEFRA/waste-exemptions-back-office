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

      context "when the registration is not legacy bulk or linear" do
        before { registration.update(is_legacy_bulk: false, is_linear: false) }

        it_behaves_like "sends a Notify message with the correct template id and with a renewal link" do
          let(:cassette_name) { "first_renewal_reminder_email" }
          let(:template_id) { Templates::FIRST_RENEWAL_REMINDER }
        end
      end

      context "when the registration is legacy bulk" do
        before { registration.update(is_legacy_bulk: true) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "first_renewal_reminder_email_LB" }
          let(:template_id) { Templates::RENEWAL_REMINDER_LEGACY_BULK }
        end
      end

      context "when the registration is linear" do
        before { registration.update(is_linear: true) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "first_renewal_reminder_email_LN" }
          let(:template_id) { Templates::RENEWAL_REMINDER_LINEAR }
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
