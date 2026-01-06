# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe FreeSecondRenewalReminderEmailService do
    describe "run" do
      let(:registration) { create(:registration, :site_uses_address) }
      let(:run_service) { described_class.run(registration: registration) }

      context "when the registration is not legacy bulk" do
        before { registration.update(is_legacy_bulk: false) }

        let(:cassette) { "second_free_renewal_reminder_email" }
        let(:template) { "f308a8a9-0358-41e1-b633-ea4044ad9580" }

        it_behaves_like "sends a Notify message with the correct template id and with a renewal link" do
          let(:cassette_name) { cassette }
          let(:template_id) { template }
        end
      end

      context "when the registration is legacy bulk" do
        before { registration.update(is_legacy_bulk: true) }

        let(:cassette) { "second_free_renewal_reminder_email_LB" }
        let(:template) { "69a8254e-2bd0-4e09-b27a-ad7e8a29d783" }

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
