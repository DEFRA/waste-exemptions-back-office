# frozen_string_literal: true

require "rails_helper"

RSpec.describe OctoberReformCommsEmailService do
  describe ".run" do
    subject(:run_service) { described_class.run(email: "contact@example.com", registrations:) }

    let(:registrations) { create_list(:registration, 2, contact_email: "contact@example.com") }

    let(:notify_client) { instance_double(Notifications::Client) }
    let(:notify_response) do
      instance_double(Notifications::Client::ResponseNotification,
                      id: "notification-id",
                      content: { "subject" => "Waste exemptions are changing", "body" => "Email body" })
    end

    before do
      allow(Notifications::Client).to receive(:new).and_return(notify_client)
      allow(notify_client).to receive(:send_email).and_return(notify_response)
    end

    it "sends the email to the contact email address" do
      run_service

      expect(notify_client).to have_received(:send_email)
        .with(email_address: "contact@example.com", template_id: described_class::TEMPLATE_ID)
    end

    it "returns the Notify response" do
      expect(run_service).to eq(notify_response)
    end

    it "records the email in the communication history of each registration" do
      run_service

      registrations.each do |registration|
        expect(registration.reload.communication_logs.sole).to have_attributes(
          message_type: "email",
          template_id: described_class::TEMPLATE_ID,
          template_label: "Reform comms email - October 2026",
          sent_to: "contact@example.com",
          notification_id: "notification-id",
          subject: "Waste exemptions are changing",
          body: "Email body"
        )
      end
    end

    context "when Notify sends the delivery receipt for the email" do
      before do
        run_service

        WasteExemptionsEngine::NotifyCallbackJob.perform_now(
          "id" => "notification-id",
          "to" => "contact@example.com",
          "status" => "delivered",
          "notification_type" => "email"
        )
      end

      it "updates the status in the communication history of each registration" do
        registrations.each do |registration|
          expect(registration.reload.communication_logs.sole.status).to eq("delivered")
        end
      end
    end
  end
end
