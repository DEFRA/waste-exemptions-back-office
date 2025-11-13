# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe FreeFirstRenewalReminderEmailService do
    describe "run" do
      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration) }

      context "when the registration is not legacy_bulk or multi-site" do
        before { registration.update(is_legacy_bulk: false, is_multisite_registration: false) }

        it_behaves_like "sends a Notify message with the correct template id and with a renewal link" do
          let(:cassette_name) { "free_first_renewal_reminder_email" }
          let(:template_id) { "b1c9cda2-b502-4667-b22c-63e8725f7a27" }
        end
      end

      it_behaves_like "legacy bulk or multisite reminder" do
        let(:cassette_name) { "renewal_reminder_email_multisite_enable_renewals_on" }
        let(:template_id) { "cda801d8-ad08-4e77-ab46-94b0e9689ed7" }
      end

      it_behaves_like "opted out of renewal reminder"

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:parameters) { { registration: create(:registration) } }
      end
    end
  end
end
