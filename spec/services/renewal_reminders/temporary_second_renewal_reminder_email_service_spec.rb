# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe TemporarySecondRenewalReminderEmailService do
    describe ".run" do
      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration, :with_active_exemptions) }

      context "when the registration is not legacy bulk or linear" do
        before { registration.update(is_legacy_bulk: false, is_linear: false) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "temporary_second_renewal_reminder_email" }
          let(:template_id) { Templates::RENEWAL_REMINDER_TEMPORARY }
        end
      end

      context "when the registration is legacy bulk" do
        before { registration.update(is_legacy_bulk: true) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "temporary_second_renewal_reminder_email_LB" }
          let(:template_id) { Templates::RENEWAL_REMINDER_LEGACY_BULK }
        end
      end

      context "when the registration is linear" do
        before { registration.update(is_linear: true) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "temporary_second_renewal_reminder_email_LN" }
          let(:template_id) { Templates::RENEWAL_REMINDER_LINEAR }
        end
      end

      it "includes a registration URL instead of a renewal link" do
        service = described_class.new
        service.instance_variable_set(:@registration, registration)

        personalisation = service.send(:personalisation)

        expect(personalisation[:magic_link_url]).to include("start")
        expect(personalisation[:magic_link_url]).not_to include("renew")
      end
    end
  end
end
