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


    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration) } }
    end
  end
end
