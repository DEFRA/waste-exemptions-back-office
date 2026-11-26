# frozen_string_literal: true

require "rails_helper"

RSpec.describe FollowUpReformCommsLetterService do
  describe ".run" do
    subject(:run_service) { described_class.run(**letter_args) }

    let(:letter_args) do
      { unique_reference: "A12BC9", first_name: "Jane", last_name: "Smith",
        address_lines: ["Acme Ltd", "1", "High Street", "Bristol", "BS1 1AA"], registrations: }
    end
    let(:registrations) { create_list(:registration, 2) }

    let(:notify_client) { instance_double(Notifications::Client) }
    let(:notify_response) do
      instance_double(Notifications::Client::ResponseNotification,
                      id: "notification-id",
                      content: { "subject" => "Waste exemptions are changing",
                                 "body" => "Quote reference A12BC9 when you contact us" })
    end

    before do
      allow(Notifications::Client).to receive(:new).and_return(notify_client)
      allow(notify_client).to receive(:send_letter).and_return(notify_response)
    end

    it_behaves_like "a reform comms letter service"

    it "sends one letter with the unique reference and the registration numbers, using the reference for Notify too" do
      run_service

      expect(notify_client).to have_received(:send_letter).once.with(
        template_id: described_class::TEMPLATE_ID,
        reference: "A12BC9",
        personalisation: {
          first_name: "Jane",
          last_name: "Smith",
          "address_line_1" => "Jane Smith",
          "address_line_2" => "Acme Ltd",
          "address_line_3" => "1",
          "address_line_4" => "High Street",
          "address_line_5" => "Bristol",
          "address_line_6" => "BS1 1AA",
          unique_reference: "A12BC9",
          registration_numbers: registrations.map(&:reference).join(", ")
        }
      )
    end

    it "uses a different Notify template from the October reform comms letter" do
      expect(described_class::TEMPLATE_ID).not_to eq(OctoberReformCommsLetterService::TEMPLATE_ID)
    end
  end
end
