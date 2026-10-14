# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendOctoberReformCommsEmailsService do
  subject(:service) { described_class.run(dry_run:) }

  let(:dry_run) { false }
  let(:template_id) { OctoberReformCommsEmailService::TEMPLATE_ID }

  let(:notify_client) { instance_double(Notifications::Client) }
  let(:rate_limit_error) do
    Notifications::Client::RateLimitError.new(
      instance_double(Net::HTTPResponse,
                      code: "429",
                      body: { errors: [{ error: "RateLimitError", message: "Exceeded rate limit" }] }.to_json)
    )
  end

  let(:shared_email_registrations) do
    [
      create(:registration, contact_email: "shared@example.com"),
      create(:registration, contact_email: " Shared@Example.com "),
      create(:registration, contact_email: "SHARED@example.com",
                            registration_exemptions: [build(:registration_exemption, :active),
                                                      build(:registration_exemption, :ceased)])
    ]
  end
  let(:single_email_registration) { create(:registration, contact_email: "single@example.com") }

  before do
    allow(Notifications::Client).to receive(:new).and_return(notify_client)
    allow(notify_client).to receive(:send_email) do |email_address:, **|
      instance_double(Notifications::Client::ResponseNotification,
                      id: "#{email_address}-notification-id",
                      content: { "subject" => "Waste exemptions are changing", "body" => "Email body" })
    end
    allow(Airbrake).to receive(:notify)

    shared_email_registrations
    single_email_registration

    create(:registration, contact_email: "ceased@example.com",
                          registration_exemptions: build_list(:registration_exemption, 2, :ceased))
    create(:registration, contact_email: "revoked@example.com",
                          registration_exemptions: [build(:registration_exemption, :revoked)])
    create(:registration, contact_email: "expired@example.com",
                          registration_exemptions: [build(:registration_exemption, :expired)])
    create(:registration, contact_email: "past-expiry@example.com",
                          registration_exemptions: [build(:registration_exemption, :active,
                                                          expires_on: Time.zone.yesterday)])
    create(:registration, contact_email: nil)
    create(:registration, contact_email: " ")
  end

  describe ".run" do
    it "sends one email to each unique contact email address on an active registration" do
      service

      expect(notify_client).to have_received(:send_email).twice
      expect(notify_client).to have_received(:send_email)
        .with(email_address: "shared@example.com", template_id:).once
      expect(notify_client).to have_received(:send_email)
        .with(email_address: "single@example.com", template_id:).once
    end

    it "returns the number of emails sent" do
      expect(service).to eq(2)
    end

    it "shows the email in the communication history of every registration with that contact email" do
      service

      shared_email_registrations.each do |registration|
        expect(registration.reload.communication_logs.map(&:notification_id))
          .to eq(["shared@example.com-notification-id"])
      end
    end

    context "when there are more emails than fit in one batch" do
      let(:service_instance) { described_class.new }

      before do
        stub_const("#{described_class}::RATE_LIMIT", 2) # batches of 1 email
        allow(described_class).to receive(:new).and_return(service_instance)
        allow(service_instance).to receive(:sleep)
      end

      it "sends every email" do
        expect(service).to eq(2)
      end

      it "waits a minute between batches to stay within the Notify rate limit" do
        service

        expect(service_instance).to have_received(:sleep).with(a_value_within(1).of(60)).once
      end

      context "when it is a dry run" do
        let(:dry_run) { true }

        it "does not wait between batches" do
          service

          expect(service_instance).not_to have_received(:sleep)
        end
      end
    end

    context "when Notify rejects an email for exceeding a limit" do
      before do
        create(:registration, contact_email: "later@example.com")

        allow(notify_client).to receive(:send_email)
          .with(hash_including(email_address: "single@example.com"))
          .and_raise(rate_limit_error)
      end

      it "stops sending" do
        service

        expect(notify_client).not_to have_received(:send_email).with(hash_including(email_address: "later@example.com"))
      end

      it "reports the error to Airbrake once" do
        service

        expect(Airbrake).to have_received(:notify).once
        expect(Airbrake).to have_received(:notify).with(rate_limit_error)
      end

      it "returns the number of emails sent before it stopped" do
        expect(service).to eq(1)
      end
    end

    context "when a contact email address has already been sent the email" do
      before do
        single_email_registration.communication_logs << create(:communication_log, :email,
                                                               template_id:, sent_to: "Single@example.com")
      end

      it "does not send it again" do
        service

        expect(notify_client).to have_received(:send_email).once
        expect(notify_client).not_to have_received(:send_email).with(hash_including(email_address: "single@example.com"))
      end
    end

    context "when sending an email fails" do
      before do
        allow(notify_client).to receive(:send_email)
          .with(hash_including(email_address: "shared@example.com"))
          .and_raise(StandardError, "Notify error")
      end

      it "reports the error to Airbrake" do
        service

        expect(Airbrake).to have_received(:notify)
          .with(an_instance_of(StandardError), registration: shared_email_registrations.map(&:reference).join(", "))
      end

      it "carries on sending to the other contact email addresses" do
        service

        expect(notify_client).to have_received(:send_email).with(hash_including(email_address: "single@example.com"))
      end

      it "does not record the email in the communication history" do
        service

        shared_email_registrations.each do |registration|
          expect(registration.reload.communication_logs).to be_empty
        end
      end

      it "does not count the failed email" do
        expect(service).to eq(1)
      end
    end

    context "when it is a dry run" do
      let(:dry_run) { true }

      it "does not send any emails" do
        service

        expect(notify_client).not_to have_received(:send_email)
      end

      it "does not record anything in the communication history" do
        expect { service }.not_to change(WasteExemptionsEngine::CommunicationLog, :count)
      end

      it "returns the number of emails that would be sent" do
        expect(service).to eq(2)
      end
    end
  end
end
