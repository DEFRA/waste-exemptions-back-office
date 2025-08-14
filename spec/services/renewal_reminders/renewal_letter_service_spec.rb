# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe RenewalLetterService do
    describe ".run" do
      subject(:response) { described_class.run(registration: registration) }

      let(:registration) { create(:registration) }
      let(:address_instance) { instance_double(WasteExemptionsEngine::Address) }

      before do
        registration.registration_exemptions.update(expires_on: Date.new(2030, 7, 1))
        allow(WasteExemptionsEngine::Address).to receive(:new).and_return(address_instance)
        # Make sure it's a real postcode for Notify validation purposes
        allow(address_instance).to receive(:postcode).and_return("BS1 1AA")
      end

      # rubocop:disable RSpec/AnyInstance
      it "sends a letter" do
        VCR.use_cassette("notify_renewal_letter") do
          allow_any_instance_of(Notifications::Client).to receive(:send_letter).and_call_original

          expect(response).to be_a(Notifications::Client::ResponseNotification)
          expect(response.template["id"]).to eq("931a9338-9177-4470-a51a-3a6991561863")
          expect(response.content["subject"]).to include("Renew your waste exemptions")
          expect(response.content["subject"]).to include("Renew your waste exemptions by 1 July 2030")
          expect(response.content["subject"]).to include("You can renew from 3 June 2030")
        end
      end
      # rubocop:enable RSpec/AnyInstance
    end

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration) } }
    end
  end
end
