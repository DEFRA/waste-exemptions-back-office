# frozen_string_literal: true

require "rails_helper"

RSpec.describe PrivateBetaInviteEmailService do
  describe "run" do
    let(:registration) { create(:registration, :site_uses_address) }
    let(:beta_participant) { create(:beta_participant, reg_number: registration.reference, email: registration.contact_email) }
    let(:run_service) { described_class.run(registration: registration, beta_participant: beta_participant) }

    it "sends an email" do
      VCR.use_cassette("private_beta_invite_email") do

        response = run_service

        expect(response).to be_a(Notifications::Client::ResponseNotification)
        expect(response.template["id"]).to eq("6d4a8a47-bf39-4299-ab44-1f00b0d9370b")
        expect(response.content["subject"]).to eq("Invite to participate in Private beta")
        expect(response.content["body"]).to include(beta_participant.private_beta_start_url)
      end
    end

    it "updates the invited_at time" do
      VCR.use_cassette("private_beta_invite_email") do
        expect(beta_participant.invited_at).to be_nil
        run_service
        expect(beta_participant.reload.invited_at).to be_within(5.seconds).of(Time.current)
      end
    end

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: registration, beta_participant: beta_participant } }
    end
  end
end
