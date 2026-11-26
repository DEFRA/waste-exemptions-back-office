# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendFollowUpReformCommsLettersService do
  subject(:service) { described_class.run(batch_size:, dry_run:) }

  let(:batch_size) { 10 }
  let(:dry_run) { false }

  def create_registration(first_name: "Jane", last_name: "Smith", registration_exemptions: nil, **address)
    attributes = { contact_first_name: first_name, contact_last_name: last_name, registration_exemptions: }.compact
    registration = create(:registration, **attributes)
    registration.contact_address.update(organisation: nil, premises: "1", street_address: "High Street",
                                        locality: nil, city: "Bristol", postcode: "BS1 1AA", **address)
    registration
  end

  # Adds a reform comms email to the registration's communication history, ending in the given Notify status
  def add_email(registration, status:, template_label: FollowUpReformCommsEmailService::TEMPLATE_LABEL)
    registration.communication_logs << create(:communication_log, :email,
                                              template_id: FollowUpReformCommsEmailService::TEMPLATE_ID,
                                              template_label:, status:)
    registration
  end

  def add_letter(registration, template_id:, status: "sent", **attributes)
    registration.communication_logs << create(:communication_log, :letter, template_id:, status:, **attributes)
    registration
  end

  # Active, with a follow-up email Notify did not deliver
  def create_eligible_registration(**)
    add_email(create_registration(**), status: "permanent-failure")
  end

  before do
    allow(FollowUpReformCommsLetterService).to receive(:run)
    allow(Airbrake).to receive(:notify)
  end

  describe ".run" do
    it_behaves_like "a reform comms letters sender" do
      let(:letter_service) { FollowUpReformCommsLetterService }
    end

    it "sends a letter to registrations whose follow-up email ended in any of the undelivered statuses" do
      %w[temporary-failure technical-failure].each do |status|
        add_email(create_registration(first_name: status), status:)
      end

      service

      expect(FollowUpReformCommsLetterService).to have_received(:run).twice
    end

    context "when Notify has not reported a failure for the follow-up email" do
      before do
        %w[delivered sent sending].each { |status| add_email(create_registration(first_name: status), status:) }
      end

      it "does not send a letter" do
        service

        expect(FollowUpReformCommsLetterService).not_to have_received(:run)
      end
    end

    context "when only the original reform comms email failed" do
      before do
        add_email(create_registration, status: "permanent-failure",
                                       template_label: OctoberReformCommsEmailService::TEMPLATE_LABEL)
      end

      it "does not send a letter" do
        service

        expect(FollowUpReformCommsLetterService).not_to have_received(:run)
      end
    end

    context "when the registration has no active exemptions" do
      before do
        create_eligible_registration(registration_exemptions: build_list(:registration_exemption, 2, :ceased))
        create_eligible_registration(first_name: "Tom", registration_exemptions: [build(:registration_exemption, :revoked)])
      end

      it "does not send a letter" do
        service

        expect(FollowUpReformCommsLetterService).not_to have_received(:run)
      end
    end

    context "when a later follow-up email was delivered" do
      before { add_email(create_eligible_registration, status: "delivered") }

      it "does not send a letter" do
        service

        expect(FollowUpReformCommsLetterService).not_to have_received(:run)
      end
    end

    context "when registrations sharing a contact have different letter histories" do
      let!(:october_letter_registration) do
        add_letter(create_eligible_registration, template_id: OctoberReformCommsLetterService::TEMPLATE_ID)
      end

      before do
        add_letter(create_eligible_registration, template_id: FollowUpReformCommsLetterService::TEMPLATE_ID,
                                                 status: "permanent-failure")
      end

      it "sends one letter, covering only the registration without the follow-up letter" do
        service

        expect(FollowUpReformCommsLetterService).to have_received(:run)
          .with(hash_including(registrations: [october_letter_registration])).once
      end
    end

    context "when the letter goes to Notify" do
      let(:notify_client) { instance_double(Notifications::Client) }
      let(:sent_letters) { [] }
      let!(:registrations) { [create_eligible_registration, create_eligible_registration(first_name: " JANE ")] }

      before do
        allow(FollowUpReformCommsLetterService).to receive(:run).and_call_original
        allow(Notifications::Client).to receive(:new).and_return(notify_client)
        allow(notify_client).to receive(:send_letter) do |args|
          sent_letters << args
          instance_double(Notifications::Client::ResponseNotification, id: "notification-id",
                                                                       content: { "body" => "Letter body" })
        end
      end

      it "sends one letter, using the unique reference in it as the Notify reference too" do
        service

        expect(sent_letters.sole).to include(reference: sent_letters.sole[:personalisation][:unique_reference])
      end

      it "records the letter in the communication history of each registration it covers" do
        service

        registrations.each do |registration|
          expect(registration.reload.communication_logs.map(&:template_id))
            .to include(FollowUpReformCommsLetterService::TEMPLATE_ID)
        end
      end
    end

    describe "unique reference" do
      before do
        create_eligible_registration
        create_eligible_registration(first_name: "Tom")
      end

      it "sends each letter with a reference of six capital letters or digits" do
        service

        expect(FollowUpReformCommsLetterService).to have_received(:run)
          .with(hash_including(unique_reference: /\A[A-Z0-9]{6}\z/)).twice
      end

      context "when a reference has already been used in the run" do
        before { allow(SecureRandom).to receive(:alphanumeric).and_return("A12BC9", "A12BC9", "D34EF5") }

        it "sends the next letter with a different reference" do
          service

          %w[A12BC9 D34EF5].each do |unique_reference|
            expect(FollowUpReformCommsLetterService).to have_received(:run)
              .with(hash_including(unique_reference:)).once
          end
        end
      end

      context "when a reference was sent in an earlier run" do
        before do
          add_letter(create_registration(first_name: "Earlier"),
                     template_id: FollowUpReformCommsLetterService::TEMPLATE_ID,
                     body: "Dear Earlier Smith,\n\nQuote reference **A12BC9** when you contact us.")
          allow(SecureRandom).to receive(:alphanumeric).and_return("A12BC9", "D34EF5", "G56HJ7")
        end

        it "does not send it again" do
          service

          expect(FollowUpReformCommsLetterService).not_to have_received(:run)
            .with(hash_including(unique_reference: "A12BC9"))
        end
      end

      context "when running in dry run mode" do
        let(:dry_run) { true }

        before { allow(SecureRandom).to receive(:alphanumeric).and_call_original }

        it "does not generate references" do
          service

          expect(SecureRandom).not_to have_received(:alphanumeric)
        end
      end
    end
  end
end
