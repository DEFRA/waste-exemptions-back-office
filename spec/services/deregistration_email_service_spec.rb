# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeregistrationEmailService do
  describe "run" do
    subject(:run_service) do
      described_class.run(
        registration: registration,
        recipient: registration.contact_email
      )
    end

    let(:registration) { create(:registration) }

    let(:expected_params) do
      {
        email_address: registration.contact_email,
        template_id: "9148895b-e239-4118-8ffd-dadd9b2cf462",
        personalisation: {
          contact_name: "#{registration.contact_first_name} #{registration.contact_last_name}",
          exemption_details: registration.exemptions.order(:exemption_id).map do |ex|
            "#{ex.code} #{ex.summary}"
          end.join(", "),
          magic_link_url: "http://localhost:3000/renew/#{registration.renew_token}",
          reference: registration.reference,
          site_details: "ST 58337 72855"
        }
      }
    end

    let(:notifications_client) { instance_double(Notifications::Client) }

    before do
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email)
    end

    it "sends an email" do
      run_service

      expect(notifications_client).to have_received(:send_email).with(expected_params)
    end

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration), recipient: registration.contact_email } }
    end
  end
end
