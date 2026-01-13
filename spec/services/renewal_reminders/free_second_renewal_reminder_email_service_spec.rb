# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe FreeSecondRenewalReminderEmailService do
    describe "run" do
      let(:registration) { create(:registration, :site_uses_address) }
      let(:run_service) { described_class.run(registration: registration) }

      context "when the registration is not legacy bulk or linear" do
        before { registration.update(is_legacy_bulk: false, is_linear: false) }

        let(:cassette) { "second_free_renewal_reminder_email" }
        let(:template) { Templates::SECOND_RENEWAL_REMINDER }

        it_behaves_like "sends a Notify message with the correct template id and with a renewal link" do
          let(:cassette_name) { cassette }
          let(:template_id) { template }
        end
      end

      context "when the registration is legacy bulk" do
        before { registration.update(is_legacy_bulk: true) }

        let(:cassette) { "second_free_renewal_reminder_email_LB" }
        let(:template) { Templates::RENEWAL_REMINDER_LEGACY_BULK }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { cassette }
          let(:template_id) { template }
        end
      end

      context "when the registration is linear" do
        before { registration.update(is_linear: true) }

        let(:cassette) { "second_free_renewal_reminder_email_LN" }
        let(:template) { Templates::RENEWAL_REMINDER_LINEAR }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { cassette }
          let(:template_id) { template }
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
