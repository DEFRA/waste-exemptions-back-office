# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe FreeFirstRenewalReminderEmailService do
    describe "run" do
      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration) }

      context "when the registration is not legacy bulk" do
        before { registration.update(is_legacy_bulk: false) }

        let(:cassette) { "free_first_renewal_reminder_email" }
        let(:template) { "b1c9cda2-b502-4667-b22c-63e8725f7a27" }

        it_behaves_like "sends a Notify message with the correct template id and with a renewal link" do
          let(:cassette_name) { cassette }
          let(:template_id) { template }
        end
      end

      context "when the registration is legacy bulk" do
        before { registration.update(is_legacy_bulk: true) }

        let(:cassette) { "free_first_renewal_reminder_email_LB" }
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
