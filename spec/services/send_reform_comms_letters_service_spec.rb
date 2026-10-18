# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendReformCommsLettersService do
  subject(:service) { described_class.run(batch_size:, dry_run:) }

  let(:batch_size) { 10 }
  let(:dry_run) { false }
  let(:template_id) { ReformCommsLetterService::TEMPLATE_ID }

  let(:notify_client) { instance_double(Notifications::Client) }
  let(:rate_limit_error) { notify_error(Notifications::Client::RateLimitError, "429", "RateLimitError") }
  let(:bad_request_error) { notify_error(Notifications::Client::BadRequestError, "400", "ValidationError") }

  # Jane Smith at 1 High Street, with the same contact recorded differently on a later registration
  let(:shared_contact_registrations) do
    [
      create_registration,
      create_registration(first_name: " JANE ", last_name: "smith", street_address: "high  street",
                          postcode: "bs11aa")
    ]
  end
  let(:same_name_other_address_registration) { create_registration(premises: "2") }
  let(:same_address_other_name_registration) { create_registration(first_name: "Tom") }

  def create_registration(first_name: "Jane", last_name: "Smith", contact_email: nil, **address)
    registration = create(:registration, contact_first_name: first_name, contact_last_name: last_name,
                                         contact_email:)
    registration.contact_address.update(organisation: nil, premises: "1", street_address: "High Street",
                                        locality: nil, city: "Bristol", postcode: "BS1 1AA", **address)
    registration
  end

  def notify_error(error_class, code, error)
    error_class.new(
      instance_double(Net::HTTPResponse,
                      code:,
                      body: { errors: [{ error:, message: "Rejected by Notify" }] }.to_json)
    )
  end

  before do
    allow(Notifications::Client).to receive(:new).and_return(notify_client)
    allow(notify_client).to receive(:send_letter) do |personalisation:, **|
      instance_double(Notifications::Client::ResponseNotification,
                      id: "#{personalisation['address_line_1']}-#{personalisation['address_line_2']}",
                      content: { "subject" => "Waste exemptions are changing", "body" => "Letter body" })
    end
    allow(Airbrake).to receive(:notify)

    shared_contact_registrations
    same_name_other_address_registration
    same_address_other_name_registration

    create_registration(contact_email: "contact@example.com")
    create_registration.tap do |registration|
      registration.registration_exemptions.each { |registration_exemption| registration_exemption.update(state: :ceased) }
    end
  end

  describe ".run" do
    it "sends one letter to each unique contact name and address on an active registration with no contact email" do
      service

      expect(notify_client).to have_received(:send_letter).exactly(3).times
    end

    it "uses the contact details of the registration with the lowest id for a shared letter" do
      service

      expect(notify_client).to have_received(:send_letter).with(
        template_id:,
        personalisation: {
          first_name: "Jane",
          last_name: "Smith",
          "address_line_1" => "Jane Smith",
          "address_line_2" => "1",
          "address_line_3" => "High Street",
          "address_line_4" => "Bristol",
          "address_line_5" => "BS1 1AA"
        }
      )
    end

    it "shows the letter in the communication history of every registration it was sent for" do
      service

      shared_contact_registrations.each do |registration|
        expect(registration.reload.communication_logs.sole).to have_attributes(
          template_id:,
          notification_id: "Jane Smith-1",
          sent_to: "Jane Smith, 1, High Street, Bristol, BS1 1AA"
        )
      end
    end

    it "returns the letters sent and the registrations they cover" do
      expect(service).to include(
        letters_sent: 3,
        registrations_covered: 4,
        letters: [
          { references: shared_contact_registrations.map(&:reference),
            recipient: "Jane Smith, 1, High Street, Bristol, BS1 1AA" },
          { references: [same_name_other_address_registration.reference],
            recipient: "Jane Smith, 2, High Street, Bristol, BS1 1AA" },
          { references: [same_address_other_name_registration.reference],
            recipient: "Tom Smith, 1, High Street, Bristol, BS1 1AA" }
        ],
        failed: [],
        unsendable: [],
        letters_remaining: 0,
        rate_limited: false
      )
    end

    context "when some registrations have already been sent the letter" do
      before { described_class.run(batch_size: 1) }

      it "does not send them the letter again" do
        service

        expect(notify_client).to have_received(:send_letter).exactly(3).times
        expect(shared_contact_registrations.first.reload.communication_logs.count).to eq(1)
      end
    end

    context "when there are more letters to send than the batch size" do
      let(:batch_size) { 2 }

      it "sends the batch size number of letters, starting from the lowest registration ids" do
        service

        expect(notify_client).to have_received(:send_letter).twice
        expect(same_address_other_name_registration.reload.communication_logs).to be_empty
      end

      it "returns the number of letters still to send" do
        expect(service).to include(letters_sent: 2, letters_remaining: 1)
      end
    end

    context "when a registration's contact address cannot be used for a letter" do
      let!(:no_address_registration) do
        create_registration.tap do |registration|
          registration.contact_address.destroy
          registration.reload
        end
      end
      let!(:no_postcode_registration) { create_registration(premises: "3", postcode: nil) }
      let!(:too_few_lines_registration) do
        create_registration(premises: nil, street_address: nil, city: nil, postcode: "BS2 2BB")
      end

      it "does not send it a letter" do
        service

        expect(notify_client).to have_received(:send_letter).exactly(3).times
      end

      it "returns it as unsendable with the reason" do
        expect(service[:unsendable]).to contain_exactly(
          { references: [no_address_registration.reference], reason: "no contact address" },
          { references: [no_postcode_registration.reference], reason: "no contact address postcode" },
          { references: [too_few_lines_registration.reference], reason: "too few contact address lines" }
        )
      end
    end

    context "when Notify rejects a letter" do
      before do
        allow(notify_client).to receive(:send_letter)
          .with(hash_including(personalisation: hash_including("address_line_2" => "2")))
          .and_raise(bad_request_error)
      end

      it "returns the registrations as unsendable with Notify's message and carries on" do
        expect(service).to include(
          letters_sent: 2,
          unsendable: [{ references: [same_name_other_address_registration.reference],
                         reason: bad_request_error.message }]
        )
      end

      it "does not record the letter in the communication history" do
        service

        expect(same_name_other_address_registration.reload.communication_logs).to be_empty
      end
    end

    context "when a letter fails to send for another reason" do
      before do
        allow(notify_client).to receive(:send_letter)
          .with(hash_including(personalisation: hash_including("address_line_2" => "2")))
          .and_raise(StandardError, "Connection reset")
      end

      it "notifies Airbrake" do
        service

        expect(Airbrake).to have_received(:notify)
          .with(an_instance_of(StandardError), registration: same_name_other_address_registration.reference)
      end

      it "returns the registrations as failed and carries on" do
        expect(service).to include(
          letters_sent: 2,
          failed: [{ references: [same_name_other_address_registration.reference], error: "Connection reset" }],
          letters_remaining: 1
        )
      end
    end

    context "when Notify rejects a letter for exceeding a limit" do
      before do
        allow(notify_client).to receive(:send_letter)
          .with(hash_including(personalisation: hash_including("address_line_2" => "2")))
          .and_raise(rate_limit_error)
      end

      it "notifies Airbrake" do
        service

        expect(Airbrake).to have_received(:notify).with(rate_limit_error)
      end

      it "stops sending letters" do
        service

        expect(same_address_other_name_registration.reload.communication_logs).to be_empty
      end

      it "returns that it was stopped by the limit, with the letters still to send" do
        expect(service).to include(letters_sent: 1, letters_remaining: 2, rate_limited: true)
      end
    end

    context "when running in dry run mode" do
      let(:dry_run) { true }

      it "does not send any letters" do
        service

        expect(notify_client).not_to have_received(:send_letter)
      end

      it "does not record anything in the communication history" do
        expect { service }.not_to change(WasteExemptionsEngine::CommunicationLog, :count)
      end

      it "returns the letters it would send" do
        expect(service).to include(letters_sent: 3, registrations_covered: 4, letters_remaining: 0)
        expect(service[:letters].pluck(:references)).to eq(
          [shared_contact_registrations.map(&:reference),
           [same_name_other_address_registration.reference],
           [same_address_other_name_registration.reference]]
        )
      end
    end
  end
end
