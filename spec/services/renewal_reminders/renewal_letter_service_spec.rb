# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe RenewalLetterService do
    describe ".run" do
      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration) }
      let(:address_instance) { instance_double(WasteExemptionsEngine::Address) }

      before do
        registration.registration_exemptions.update(expires_on: Date.new(2030, 7, 1))
        allow(WasteExemptionsEngine::Address).to receive(:new).and_return(address_instance)
        # Make sure it's a real postcode for Notify validation purposes
        allow(address_instance).to receive(:postcode).and_return("BS1 1AA")
      end

      it_behaves_like "calls notify with reference" do
        let(:send_action) { :send_letter }
        let(:reference) { registration.reference }
      end

      # rubocop:disable-next RSpec/AnyInstance
      it "sends a letter" do
        VCR.use_cassette("notify_renewal_letter") do
          allow_any_instance_of(Notifications::Client).to receive(:send_letter).and_call_original

          expect(run_service).to be_a(Notifications::Client::ResponseNotification)
          expect(run_service.template["id"]).to eq("931a9338-9177-4470-a51a-3a6991561863")
          expect(run_service.content["subject"]).to include("Renew your waste exemptions")
          expect(run_service.content["subject"]).to include("Renew your waste exemptions by 1 July 2030")
          expect(run_service.content["subject"]).to include("You can renew from 3 June 2030")
        end
      end
    end

    it_behaves_like "CanHaveCommunicationLog" do
      let(:service_class) { described_class }
      let(:parameters) { { registration: create(:registration) } }
    end
  end
end
