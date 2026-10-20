# frozen_string_literal: true

require "rails_helper"

RSpec.describe OctoberReformCommsLetterService do
  describe ".run" do
    subject(:run_service) do
      described_class.run(first_name: "Jane", last_name: "Smith", address_lines:, registrations:)
    end

    let(:address_lines) { ["Acme Ltd", "1", "High Street", "Bristol", "BS1 1AA"] }
    let(:registrations) { create_list(:registration, 2) }

    let(:notify_client) { instance_double(Notifications::Client) }
    let(:notify_response) do
      instance_double(Notifications::Client::ResponseNotification,
                      id: "notification-id",
                      content: { "subject" => "Waste exemptions are changing", "body" => "Letter body" })
    end

    before do
      allow(Notifications::Client).to receive(:new).and_return(notify_client)
      allow(notify_client).to receive(:send_letter).and_return(notify_response)
    end

    it "sends the letter to the contact, with their name as the first address line" do
      run_service

      expect(notify_client).to have_received(:send_letter).with(
        template_id: described_class::TEMPLATE_ID,
        personalisation: {
          first_name: "Jane",
          last_name: "Smith",
          "address_line_1" => "Jane Smith",
          "address_line_2" => "Acme Ltd",
          "address_line_3" => "1",
          "address_line_4" => "High Street",
          "address_line_5" => "Bristol",
          "address_line_6" => "BS1 1AA"
        }
      )
    end

    it "records the letter in the communication history of each registration" do
      run_service

      registrations.each do |registration|
        expect(registration.reload.communication_logs.sole).to have_attributes(
          message_type: "letter",
          template_id: described_class::TEMPLATE_ID,
          template_label: "Reform comms letter - October 2026",
          sent_to: "Jane Smith, Acme Ltd, 1, High Street, Bristol, BS1 1AA",
          notification_id: "notification-id"
        )
      end
    end

    context "when Notify rejects the letter" do
      let(:error) do
        Notifications::Client::BadRequestError.new(
          instance_double(Net::HTTPResponse,
                          code: "400",
                          body: { errors: [{ error: "ValidationError", message: "Rejected by Notify" }] }.to_json)
        )
      end

      before { allow(notify_client).to receive(:send_letter).and_raise(error) }

      it "records the rejection in the communication history of each registration and raises the error" do
        expect { run_service }.to raise_error(error)

        registrations.each do |registration|
          expect(registration.reload.communication_logs.sole).to have_attributes(
            template_id: described_class::TEMPLATE_ID,
            status: "permanent-failure"
          )
        end
      end
    end
  end

  it_behaves_like "CanHaveCommunicationLog" do
    let(:service_class) { described_class }
    let(:parameters) do
      { first_name: "Jane", last_name: "Smith", address_lines: ["1 High Street", "BS1 1AA"],
        registrations: [create(:registration)] }
    end
  end
end
