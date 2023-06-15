# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/AnyInstance
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

    it "sends an email" do
      expect_any_instance_of(Notifications::Client)
        .to receive(:send_email).with(expected_params)

      run_service
    end
  end
end
# rubocop:enable RSpec/AnyInstance
