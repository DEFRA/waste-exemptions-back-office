# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe TemporaryFirstRenewalReminderEmailService do
    describe ".run" do
      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration, :with_active_exemptions) }

      it "returns a Notify response" do
        VCR.use_cassette("temporary_first_renewal_reminder_email") do
          expect(run_service).to be_a(Notifications::Client::ResponseNotification)
        end
      end

      it "creates a communication log" do
        VCR.use_cassette("temporary_first_renewal_reminder_email") do
          expect { run_service }
            .to change { registration.communication_logs.count }.by(1)
        end
      end

      shared_examples "uses the correct template id" do
        it do
          VCR.use_cassette(cassette_name) do
            expect(run_service.template["id"]).to eq(template_id)
          end
        end
      end

      context "when the registration is not legacy bulk or linear" do
        before { registration.update(is_legacy_bulk: false, is_linear: false) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "temporary_first_renewal_reminder_email" }
          let(:template_id) { "5a4f6146-1952-4e62-9824-ab5d0bd9a978" }
        end
      end

      context "when the registration is legacy bulk" do
        before { registration.update(is_legacy_bulk: true) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "temporary_first_renewal_reminder_email_LB" }
          let(:template_id) { Templates::RENEWAL_REMINDER_LEGACY_BULK }
        end
      end

      context "when the registration is linear" do
        before { registration.update(is_linear: true) }

        it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
          let(:cassette_name) { "temporary_first_renewal_reminder_email_LN" }
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
