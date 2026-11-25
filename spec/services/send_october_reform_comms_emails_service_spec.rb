# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendOctoberReformCommsEmailsService do
  subject(:service) { described_class.run(dry_run:, output:) }

  let(:dry_run) { false }
  let(:output) { StringIO.new }
  let(:template_id) { OctoberReformCommsEmailService::TEMPLATE_ID }

  let(:notify_client) { instance_double(Notifications::Client) }

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
    # NotifyClient passes the arguments on to Notify as a single hash
    allow(notify_client).to receive(:send_email) do |args|
      instance_double(Notifications::Client::ResponseNotification,
                      id: "#{args[:email_address]}-notification-id",
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
    it_behaves_like "a reform comms emails sender" do
      let(:registrations_by_email) do
        { "shared@example.com" => shared_email_registrations,
          "single@example.com" => [single_email_registration] }
      end
      let(:totals_label) { "Reform comms emails" }
    end

    it "does not send to a registration without a current exemption" do
      service

      ["ceased@example.com", "revoked@example.com", "expired@example.com", "past-expiry@example.com"]
        .each do |email_address|
          expect(notify_client).not_to have_received(:send_email).with(hash_including(email_address:))
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
  end
end
