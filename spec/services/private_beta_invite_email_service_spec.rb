# frozen_string_literal: true

require "rails_helper"

RSpec.describe PrivateBetaInviteEmailService do
  describe "run" do
    subject(:run_service) { described_class.run(registration: registration, beta_participant: beta_participant) }

    let(:registration) { create(:registration, :site_uses_address) }
    let(:beta_participant) { create(:beta_participant, reg_number: registration.reference, email: registration.contact_email) }
    let(:notifications_client) { instance_double(Notifications::Client) }

    before do
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email)
    end

    it "sends an email" do
      personalisation = {
        contact_name: "Firstcontact1 Lastcontact1",
        exemptions: ["F1 Use of spam in cooking", "F2 Use of spam in cooking", "F3 Use of spam in cooking"],
        expiry_date: registration.registration_exemptions.first.expires_on.to_fs(:day_month_year),
        private_beta_start_url: "http://localhost:3000/beta/MyString/start",
        reference: "WEX000001",
        site_location: "premises_3, street_address_3, locality_3, city_3, BS33AA"
      }

      run_service

      expect(notifications_client).to have_received(:send_email)
        .with(hash_including(
                email_address: beta_participant.email,
                template_id: "6d4a8a47-bf39-4299-ab44-1f00b0d9370b",
                personalisation: personalisation
              ))
    end

    it "updates the invited_at time" do
      expect(beta_participant.invited_at).to be_nil
      run_service
      expect(beta_participant.reload.invited_at).to be_within(5.seconds).of(Time.current)
    end

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: registration, beta_participant: beta_participant } }
    end
  end
end
