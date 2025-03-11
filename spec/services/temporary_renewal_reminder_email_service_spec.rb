# frozen_string_literal: true

require "rails_helper"

RSpec.describe TemporaryRenewalReminderEmailService do
  describe "run" do

    subject(:run_service) { described_class.run(registration: registration) }

    let(:registration) { create(:registration) }
    let(:response_notification) { instance_double(Notifications::Client::ResponseNotification) }
    let(:notifications_client) { instance_double(Notifications::Client) }

    before do
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email).and_return(response_notification)
      allow(response_notification).to receive_messages(template: { "id" => "5a4f6146-1952-4e62-9824-ab5d0bd9a978" }, content: { "subject" => "register again" })

      # For the opted out of renewal reminder shared example
      allow(described_class).to receive(:run).and_call_original
      allow(described_class).to receive(:run).with(hash_including(skip_opted_out_check: true)).and_return(response_notification)
    end

    it "sends an email" do
      expect(run_service).to eq(response_notification)
      expect(response_notification.template["id"]).to eq("5a4f6146-1952-4e62-9824-ab5d0bd9a978")
      expect(response_notification.content["subject"]).to include("register again")
    end

    it "includes a registration URL instead of a renewal link" do
      expect(notifications_client).to receive(:send_email) do |args|
        expect(args[:personalisation][:magic_link_url]).to include("start")
        response_notification
      end

      run_service
    end

    context "when the user has opted out of reminders" do
      let(:registration) { create(:registration, reminder_opt_in: false) }

      it "does not send an email" do
        expect(run_service).not_to eq(response_notification)
      end

      it "creates an opted out communication log" do
        run_service

        log_instance = WasteExemptionsEngine::CommunicationLog.first

        expect(log_instance.message_type).to eq "email"
        expect(log_instance.template_id).to be_nil
        expect(log_instance.template_label).to eq "User is opted out - No renewal reminder email sent"
        expect(log_instance.sent_to).to eq registration.contact_email
      end

      it "still sends an email if skip_opted_out_check is true" do
        expect(described_class.run(registration: registration, skip_opted_out_check: true)).to eq(response_notification)
      end
    end

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration) } }
    end
  end
end
