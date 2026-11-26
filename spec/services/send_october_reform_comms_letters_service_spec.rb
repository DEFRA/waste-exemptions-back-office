# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendOctoberReformCommsLettersService do
  subject(:service) { described_class.run(batch_size:, dry_run:) }

  let(:batch_size) { 10 }
  let(:dry_run) { false }

  def create_registration(first_name: "Jane", last_name: "Smith", contact_email: nil, **address)
    registration = create(:registration, contact_first_name: first_name, contact_last_name: last_name,
                                         contact_email:)
    registration.contact_address.update(organisation: nil, premises: "1", street_address: "High Street",
                                        locality: nil, city: "Bristol", postcode: "BS1 1AA", **address)
    registration
  end

  # Active, with no contact email
  def create_eligible_registration(**) = create_registration(**)

  before do
    allow(OctoberReformCommsLetterService).to receive(:run)

    create_registration(contact_email: "contact@example.com")
    create_registration.tap do |registration|
      registration.registration_exemptions.each { |registration_exemption| registration_exemption.update(state: :ceased) }
    end
  end

  describe ".run" do
    it_behaves_like "a reform comms letters sender" do
      let(:letter_service) { OctoberReformCommsLetterService }
    end

    it "does not send letters to registrations with a contact email or no active exemptions" do
      service

      expect(OctoberReformCommsLetterService).not_to have_received(:run)
    end

    it "sends the letter with the recipient's name and address" do
      registration = create_registration(first_name: "Tom")

      service

      expect(OctoberReformCommsLetterService).to have_received(:run).with(
        first_name: "Tom", last_name: "Smith", address_lines: ["1", "High Street", "Bristol", "BS1 1AA"],
        registrations: [registration]
      )
    end

    context "when no batch size is given" do
      subject(:service) { described_class.run(dry_run:) }

      before do
        stub_const("ReformCommsLettersSender::DEFAULT_BATCH_SIZE", 1)
        create_registration
        create_registration(first_name: "Tom")
      end

      it "sends the default batch size of letters" do
        expect(service).to include(letters_sent: 1, letters_remaining: 1)
      end
    end
  end
end
