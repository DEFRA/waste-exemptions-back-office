# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeleteRegistrationWithoutExemptionsService do
  subject(:service) { described_class }

  describe ".run" do
    context "when the registration exists and has no exemptions" do
      let!(:registration) { create(:registration, registration_exemptions: []) }

      it "deletes the registration" do
        expect { service.run(reference: registration.reference) }
          .to change { WasteExemptionsEngine::Registration.where(id: registration.id).count }.from(1).to(0)
      end

      it "deletes the registration's addresses" do
        expect { service.run(reference: registration.reference) }
          .to change { WasteExemptionsEngine::Address.where(registration_id: registration.id).count }.to(0)
      end

      it "deletes the registration's account" do
        expect { service.run(reference: registration.reference) }
          .to change { WasteExemptionsEngine::Account.where(registration_id: registration.id).count }.to(0)
      end

      it "returns :deleted" do
        expect(service.run(reference: registration.reference)).to eq(:deleted)
      end

      it "deletes the registration's paper trail versions", :versioning do
        registration
        service.run(reference: registration.reference)
        versions = PaperTrail::Version.where(item_type: "WasteExemptionsEngine::Registration", item_id: registration.id)
        expect(versions).to be_empty
      end
    end

    context "when the registration has exemptions" do
      let!(:registration) { create(:registration) }

      it "does not delete it" do
        expect { service.run(reference: registration.reference) }
          .not_to change { WasteExemptionsEngine::Registration.where(id: registration.id).count }
      end

      it "returns :has_exemptions" do
        expect(service.run(reference: registration.reference)).to eq(:has_exemptions)
      end
    end

    context "when no registration matches the reference" do
      before { create(:registration, registration_exemptions: []) }

      it "returns :not_found" do
        expect(service.run(reference: "WEX000000")).to eq(:not_found)
      end

      it "does not delete anything" do
        expect { service.run(reference: "WEX000000") }
          .not_to change(WasteExemptionsEngine::Registration, :count)
      end
    end
  end
end
