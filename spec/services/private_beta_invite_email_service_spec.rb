# frozen_string_literal: true

require "rails_helper"

RSpec.describe PrivateBetaInviteEmailService do
  include WasteExemptionsEngine::ApplicationHelper

  describe "run" do
    subject(:run_service) { described_class.run(registration: registration, beta_participant: beta_participant) }

    let(:registration) { create(:registration, :site_uses_address) }
    let(:beta_participant) { create(:beta_participant, reg_number: registration.reference, email: registration.contact_email) }
    let(:notifications_client) { instance_double(Notifications::Client) }

    let(:personalisation) do
      {
        contact_name: "#{registration.contact_first_name} #{registration.contact_last_name}",
        exemptions: registration.registration_exemptions.map(&:exemption).map { |x| "#{x.code} #{x.summary}" },
        expiry_date: registration.registration_exemptions.first.expires_on.to_fs(:day_month_year),
        private_beta_start_url: beta_participant.private_beta_start_url,
        reference: registration.reference,
        site_location: site_location
      }
    end

    before do
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email)
    end

    context "when site_location is located by address" do
      let(:site_location) { displayable_address(registration.site_address).join(", ") }

      it "sends an email" do
        run_service

        expect(notifications_client).to have_received(:send_email)
          .with(hash_including(
                  email_address: beta_participant.email,
                  template_id: "6d4a8a47-bf39-4299-ab44-1f00b0d9370b",
                  personalisation: personalisation
                ))
      end
    end

    context "when site_location is located by grid_reference" do
      let(:registration) { create(:registration) }
      let(:site_location) do
        registration.site_address = create(:address, :with_grid_reference, registration: registration)
        registration.site_address.grid_reference
      end

      it "sends an email" do
        run_service

        expect(notifications_client).to have_received(:send_email)
          .with(hash_including(
                  email_address: beta_participant.email,
                  template_id: "6d4a8a47-bf39-4299-ab44-1f00b0d9370b",
                  personalisation: personalisation
                ))
      end
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
