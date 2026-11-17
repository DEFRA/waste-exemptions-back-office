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
    it_behaves_like "a reform comms emails sender" do
      let(:registrations_by_email) do
        { "corrected@example.com" => [corrected_registration],
          "shared@example.com" => shared_email_registrations }
      end
      let(:totals_label) { "Follow-up reform comms emails" }
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

    it "shows the follow-up alongside the original in the communication history" do
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
  end
end
