# frozen_string_literal: true

require "rails_helper"

RSpec.describe TemporaryRenewalReminderEmailService do
  describe "run" do

    subject(:run_service) { described_class.run(registration: registration) }

    let(:registration) { create(:registration) }
    let(:notify_client) { instance_double(Notifications::Client) }
    let(:notify_response) { instance_double(Notifications::Client::ResponseNotification) }

    before do
      allow(Notifications::Client).to receive(:new).and_return(notify_client)
      allow(notify_client).to receive(:send_email).and_return(notify_response)
      allow(notify_response).to receive(:template).and_return({ "id" => "5a4f6146-1952-4e62-9824-ab5d0bd9a978" })
      allow(notify_response).to receive(:content).and_return({ "subject" => "register again" })
      allow(WasteExemptionsEngine.configuration).to receive(:notify_api_key).and_return("test-key")
      allow(Rails.configuration).to receive(:front_office_url).and_return("http://example.com")
    end

    it "sends an email" do
      expect(run_service).to eq(notify_response)
      expect(notify_response.template["id"]).to eq("5a4f6146-1952-4e62-9824-ab5d0bd9a978")
      expect(notify_response.content["subject"]).to include("register again")
    end

    it "includes a registration URL instead of a renewal link" do
      expect(notify_client).to receive(:send_email) do |args|
        expect(args[:personalisation][:registration_url]).to include("new_start_form_path")
        expect(args[:personalisation]).not_to have_key(:magic_link_url)
        notify_response
      end

      run_service
    end

    it_behaves_like "opted out of renewal reminder"

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration) } }
    end
  end
end
