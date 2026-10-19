# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendOctoberReformCommsLettersService do
  subject(:service) { described_class.run(batch_size:, dry_run:) }

  let(:batch_size) { 10 }
  let(:dry_run) { false }

  # Jane Smith at 1 High Street, with the same contact recorded differently on another registration
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

  def fail_letter_for(registration, error)
    allow(OctoberReformCommsLetterService).to receive(:run)
      .with(hash_including(registrations: [registration]))
      .and_raise(error)
  end

  before do
    allow(OctoberReformCommsLetterService).to receive(:run)
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

      expect(OctoberReformCommsLetterService).to have_received(:run).exactly(3).times
      expect(OctoberReformCommsLetterService).to have_received(:run)
        .with(hash_including(registrations: match_array(shared_contact_registrations)))
    end

    it "sends each letter with the recipient's name and address" do
      service

      expect(OctoberReformCommsLetterService).to have_received(:run).with(
        first_name: "Tom", last_name: "Smith", address_lines: ["1", "High Street", "Bristol", "BS1 1AA"],
        registrations: [same_address_other_name_registration]
      )
    end

    it "returns the letters sent and the registrations they cover" do
      expect(service).to match(
        letters_sent: 3,
        registrations_covered: 4,
        letters: contain_exactly(
          a_hash_including(references: match_array(shared_contact_registrations.map(&:reference))),
          { references: [same_name_other_address_registration.reference],
            recipient: "Jane Smith, 2, High Street, Bristol, BS1 1AA" },
          { references: [same_address_other_name_registration.reference],
            recipient: "Tom Smith, 1, High Street, Bristol, BS1 1AA" }
        ),
        failed: [],
        unsendable: [],
        letters_remaining: 0,
        rate_limited: false
      )
    end

    context "when a registration has already been sent the letter" do
      before do
        create(:registration_communication_log,
               registration: shared_contact_registrations.first,
               communication_log: build(:communication_log, :letter,
                                        template_id: OctoberReformCommsLetterService::TEMPLATE_ID))
      end

      it "does not send it the letter again" do
        service

        expect(OctoberReformCommsLetterService).not_to have_received(:run)
          .with(hash_including(registrations: include(shared_contact_registrations.first)))
      end
    end

    context "when there are more letters to send than the batch size" do
      let(:batch_size) { 2 }

      it "sends the batch size number of letters and returns the number still to send" do
        expect(service).to include(letters_sent: 2, letters_remaining: 1)
        expect(OctoberReformCommsLetterService).to have_received(:run).twice
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

      it "returns it as unsendable with the reason, without sending it a letter" do
        expect(service).to include(
          letters_sent: 3,
          unsendable: contain_exactly(
            { references: [no_address_registration.reference], reason: "no contact address" },
            { references: [no_postcode_registration.reference], reason: "no contact address postcode" },
            { references: [too_few_lines_registration.reference], reason: "too few contact address lines" }
          )
        )
      end
    end

    context "when Notify rejects a letter" do
      let(:error) { notify_error(Notifications::Client::BadRequestError, "400", "ValidationError") }

      before { fail_letter_for(same_name_other_address_registration, error) }

      it "returns the registrations as unsendable with Notify's message and carries on" do
        expect(service).to include(
          letters_sent: 2,
          unsendable: [{ references: [same_name_other_address_registration.reference], reason: error.message }]
        )
      end
    end

    context "when a letter fails to send for another reason" do
      before { fail_letter_for(same_name_other_address_registration, StandardError.new("Connection reset")) }

      it "notifies Airbrake, returns the registrations as failed and carries on" do
        expect(service).to include(
          letters_sent: 2,
          failed: [{ references: [same_name_other_address_registration.reference], error: "Connection reset" }]
        )
        expect(Airbrake).to have_received(:notify)
          .with(an_instance_of(StandardError), registration: same_name_other_address_registration.reference)
      end
    end

    context "when Notify rejects a letter for exceeding a limit" do
      let(:error) { notify_error(Notifications::Client::RateLimitError, "429", "RateLimitError") }

      before { allow(OctoberReformCommsLetterService).to receive(:run).and_raise(error) }

      it "notifies Airbrake, stops sending and returns that it was stopped by the limit" do
        expect(service).to include(letters_sent: 0, letters_remaining: 3, rate_limited: true)
        expect(OctoberReformCommsLetterService).to have_received(:run).once
        expect(Airbrake).to have_received(:notify).with(error)
      end
    end

    context "when running in dry run mode" do
      let(:dry_run) { true }

      it "returns the letters it would send, without sending them" do
        expect(service).to include(letters_sent: 3, registrations_covered: 4, letters_remaining: 0)
        expect(OctoberReformCommsLetterService).not_to have_received(:run)
      end
    end
  end
end
