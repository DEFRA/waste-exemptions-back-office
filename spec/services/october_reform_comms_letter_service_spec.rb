# frozen_string_literal: true

require "rails_helper"

RSpec.describe OctoberReformCommsLetterService do
  describe ".run" do
    subject(:run_service) { described_class.run(**letter_args) }

    let(:letter_args) do
      { first_name: "Jane", last_name: "Smith", address_lines: ["Acme Ltd", "1", "High Street", "Bristol", "BS1 1AA"],
        registrations: }
    end
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

    it_behaves_like "a reform comms letter service"

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
  end
end
