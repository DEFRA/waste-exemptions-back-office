# frozen_string_literal: true

require "rails_helper"

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

    context "when registration is a beta participant" do
      before do
        create(:beta_participant, reg_number: registration.reference)
      end

      it "does not send an email" do
        VCR.use_cassette("second_renewal_reminder_email_beta_participant") do
          response = run_service
          expect(response).to be_nil
        end
      end

      it "creates a communication log for beta participant" do
        VCR.use_cassette("second_renewal_reminder_email_beta_participant") do
          run_service
          log = registration.communication_logs.last
          expect(log.message_type).to eq("email")
          expect(log.template_label).to eq("beta_participant")
          expect(log.sent_to).to eq(registration.contact_email)
        end
      end
    end

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration) } }
    end
  end
end
