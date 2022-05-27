# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpiredRegistrationCleanupService do
  subject(:service) { described_class }
  let(:registration) { create(:registration, :with_ceased_exemptions, :with_people) }
  let(:id) { registration.id }

  describe ".run" do
    context "when older than 7 years" do
      before do
        registration.registration_exemptions.update_all(deregistered_at: 7.years.ago)
      end

      it "deletes the registration" do
        expect { service.run }.to change { WasteExemptionsEngine::Registration.where(id: id).count }.from(1).to(0)
      end

      it "deletes registration addresses" do
        address_count = registration.addresses.count

        expect { service.run }.to change { WasteExemptionsEngine::Address.where(registration_id: id).count }.from(address_count).to(0)
      end

      it "deletes registration people" do
        people_count = registration.people.count

        expect { service.run }.to change { WasteExemptionsEngine::Person.where(registration_id: id).count }.from(people_count).to(0)
      end

      it "deletes registration registration_exemptions" do
        re_count = registration.registration_exemptions.count

        expect { service.run }.to change { WasteExemptionsEngine::RegistrationExemption.where(registration_id: id).count }.from(re_count).to(0)
      end

      it "deletes registration paper_trail version data", versioning: true do
        paper_trail_count = registration.versions.count

        expect { service.run }.to change {
          PaperTrail::Version.where(item_type: "WasteExemptionsEngine::Registration").count
        }.from(paper_trail_count).to(0)
      end
    end

    context "when a registration is newer than 7 years" do
      it "does not delete it" do
        expect { service.run }.to_not change { WasteExemptionsEngine::Registration.where(id: id).count }.from(1)
      end
    end
  end
end
