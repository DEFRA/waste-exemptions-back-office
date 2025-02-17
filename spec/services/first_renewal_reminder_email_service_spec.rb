# frozen_string_literal: true

require "rails_helper"

RSpec.describe FirstRenewalReminderEmailService do
  describe "run" do

    subject(:run_service) { described_class.run(registration: registration) }

    let(:registration) { create(:registration) }

    it "sends an email" do
      VCR.use_cassette("first_renewal_reminder_email") do
        expect(run_service).to be_a(Notifications::Client::ResponseNotification)
        expect(run_service.template["id"]).to eq("1ef273a9-b5e5-4a48-a343-cf6c774b8211")
        expect(run_service.content["subject"]).to include("renew online now")
      end
    end

    it_behaves_like "opted out of renewal reminder"

    context "when registration is a beta participant" do
      before do
        create(:beta_participant, reg_number: registration.reference)
      end

      it "does not send an email" do
        VCR.use_cassette("first_renewal_reminder_email_beta_participant") do
          response = run_service
          expect(response).to be_nil
        end
      end

      it "creates a communication log for beta participant" do
        VCR.use_cassette("first_renewal_reminder_email_beta_participant") do
          run_service
          log = registration.communication_logs.last
          expect(log.message_type).to eq("email")
          expect(log.template_label).to eq("Beta participant - No renewal reminder sent")
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
