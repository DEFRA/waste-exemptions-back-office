# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendFollowUpReformCommsEmailsService do
  subject(:service) { described_class.run(dry_run:, output:) }

  let(:dry_run) { false }
  let(:output) { StringIO.new }
  let(:template_id) { FollowUpReformCommsEmailService::TEMPLATE_ID }
  let(:original_label) { "Reform comms email - October 2026" }
  let(:follow_up_label) { FollowUpReformCommsEmailService::TEMPLATE_LABEL }

  let(:notify_client) { instance_double(Notifications::Client) }
  let(:rate_limit_error) do
    Notifications::Client::RateLimitError.new(
      instance_double(Net::HTTPResponse,
                      code: "429",
                      body: { errors: [{ error: "RateLimitError", message: "Exceeded rate limit" }] }.to_json)
    )
  end

  let!(:corrected_registration) do
    registration_sent_original_email(status: "permanent-failure", sent_to: "old-address@example.com",
                                     contact_email: "corrected@example.com")
  end
  let!(:shared_email_registrations) do
    [
      registration_sent_original_email(status: "permanent-failure", contact_email: "shared@example.com"),
      registration_sent_original_email(status: "technical-failure", contact_email: " Shared@Example.com "),
      registration_sent_original_email(status: "temporary-failure", contact_email: "SHARED@example.com")
    ]
  end

  # A registration sent the original reform comms email, which ended in the given Notify status
  def registration_sent_original_email(status:, sent_to: :contact_email, **attributes)
    create(:registration, **attributes).tap do |registration|
      address = sent_to == :contact_email ? registration.contact_email : sent_to

      registration.communication_logs << create(:communication_log, :email, template_id:,
                                                                            template_label: original_label,
                                                                            sent_to: address, status:)
    end
  end

  before do
    allow(Notifications::Client).to receive(:new).and_return(notify_client)
    # NotifyClient passes the arguments on to Notify as a single hash
    allow(notify_client).to receive(:send_email) do |args|
      instance_double(Notifications::Client::ResponseNotification,
                      id: "#{args[:email_address]}-notification-id",
                      content: { "subject" => "Waste exemptions are changing", "body" => "Email body" })
    end
    allow(Airbrake).to receive(:notify)

    registration_sent_original_email(status: "delivered", contact_email: "delivered@example.com")
    registration_sent_original_email(status: "sent", contact_email: "awaiting-receipt@example.com")
    registration_sent_original_email(status: "sending", contact_email: "in-progress@example.com")

    registration_sent_original_email(status: "permanent-failure", contact_email: "ceased@example.com",
                                     registration_exemptions: build_list(:registration_exemption, 2, :ceased))
    registration_sent_original_email(status: "permanent-failure", contact_email: "revoked@example.com",
                                     registration_exemptions: [build(:registration_exemption, :revoked)])

    registration_sent_original_email(status: "permanent-failure", contact_email: nil)
    registration_sent_original_email(status: "permanent-failure", contact_email: " ")

    create(:registration, contact_email: "never-emailed@example.com")
  end

  describe ".run" do
    it "sends one email to each unique contact email address the original was not delivered to" do
      service

      expect(notify_client).to have_received(:send_email).twice
      expect(notify_client).to have_received(:send_email)
        .with(hash_including(email_address: "corrected@example.com")).once
      expect(notify_client).to have_received(:send_email)
        .with(hash_including(email_address: "shared@example.com")).once
    end

    it "sends to the contact email the registration holds now, not the address that bounced" do
      service

      expect(notify_client).not_to have_received(:send_email)
        .with(hash_including(email_address: "old-address@example.com"))
    end

    it "does not send to contact email addresses Notify has not reported a failure for" do
      service

      ["delivered@example.com", "awaiting-receipt@example.com", "in-progress@example.com"].each do |email_address|
        expect(notify_client).not_to have_received(:send_email).with(hash_including(email_address:))
      end
    end

    it "does not send to registrations that are no longer active, or were never sent the original" do
      service

      ["ceased@example.com", "revoked@example.com", "never-emailed@example.com"].each do |email_address|
        expect(notify_client).not_to have_received(:send_email).with(hash_including(email_address:))
      end
    end

    it "returns the number of emails sent" do
      expect(service).to eq(2)
    end

    it "outputs the number of emails sent and the registrations they cover" do
      service

      expect(output.string).to eq("Follow-up reform comms emails sent: 2\nRegistrations covered: 4\n")
    end

    it "shows the email in the communication history of every registration with that contact email" do
      service

      shared_email_registrations.each do |registration|
        expect(registration.reload.communication_logs.map(&:template_label))
          .to eq([original_label, follow_up_label])
      end
    end

    context "when the corrected contact email has already had the email delivered to it" do
      before do
        registration_sent_original_email(status: "delivered", contact_email: "Corrected@example.com")
      end

      it "does not send it again" do
        service

        expect(notify_client).not_to have_received(:send_email)
          .with(hash_including(email_address: "corrected@example.com"))
      end
    end

    context "when a contact email address has already been sent the follow-up" do
      before do
        corrected_registration.communication_logs << create(:communication_log, :email, template_id:,
                                                                                        template_label: follow_up_label,
                                                                                        sent_to: "Corrected@example.com",
                                                                                        status: "permanent-failure")
      end

      it "does not send it again" do
        service

        expect(notify_client).to have_received(:send_email).once
        expect(notify_client).not_to have_received(:send_email)
          .with(hash_including(email_address: "corrected@example.com"))
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
        allow(notify_client).to receive(:send_email)
          .with(hash_including(email_address: "corrected@example.com"))
          .and_raise(rate_limit_error)
      end

      it "stops sending" do
        service

        expect(notify_client).not_to have_received(:send_email)
          .with(hash_including(email_address: "shared@example.com"))
      end

      it "reports the error to Airbrake once" do
        service

        expect(Airbrake).to have_received(:notify).once
        expect(Airbrake).to have_received(:notify).with(rate_limit_error)
      end

      it "returns the number of emails sent before it stopped" do
        expect(service).to eq(0)
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

        expect(notify_client).to have_received(:send_email)
          .with(hash_including(email_address: "corrected@example.com"))
      end

      it "does not count the failed email or its registrations" do
        expect(service).to eq(1)
        expect(output.string).to include("Registrations covered: 1\n")
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

      it "outputs each email with the registrations it would be sent for, then the totals" do
        service

        expect(output.string).to eq(
          "corrected@example.com (1): #{corrected_registration.reference}\n" \
          "shared@example.com (3): #{shared_email_registrations.map(&:reference).join(', ')}\n" \
          "Follow-up reform comms emails to send: 2\n" \
          "Registrations covered: 4\n"
        )
      end
    end
  end
end
