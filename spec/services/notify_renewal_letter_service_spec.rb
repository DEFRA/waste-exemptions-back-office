# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyRenewalLetterService do
  subject(:response) { described_class.run(registration: registration) }

  describe ".run" do
    let(:registration) { create(:registration) }

    it "sends a letter" do
      VCR.use_cassette("notify_renewal_letter") do
        # Make sure it's a real postcode for Notify validation purposes
        allow_any_instance_of(WasteExemptionsEngine::Address).to receive(:postcode).and_return("BS1 1AA")

        expect_any_instance_of(Notifications::Client).to receive(:send_letter).and_call_original
        expect(response).to be_a(Notifications::Client::ResponseNotification)
        expect(response.template["id"]).to eq("931a9338-9177-4470-a51a-3a6991561863")
        expect(response.content["subject"]).to include("Renew your waste exemptions")
      end
    end
  end
end
