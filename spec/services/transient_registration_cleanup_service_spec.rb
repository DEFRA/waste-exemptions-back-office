# frozen_string_literal: true

require "rails_helper"

RSpec.describe TransientRegistrationCleanupService do
  describe ".run" do
    let(:transient_registration) { create(:new_charged_registration) }
    let(:id) { transient_registration.id }

    context "when a transient_registration is older than 30 days" do
      before do
        transient_registration.update!(created_at: 31.days.ago)
      end

      it "deletes it" do
        expect { described_class.run }.to change { WasteExemptionsEngine::TransientRegistration.where(id: id).count }.from(1).to(0)
      end

      it "deletes its transient_addresses" do
        address_count = transient_registration.addresses.count

        expect { described_class.run }.to change { WasteExemptionsEngine::TransientAddress.where(transient_registration_id: id).count }.from(address_count).to(0)
      end

      it "deletes its transient_people" do
        people_count = transient_registration.people.count

        expect { described_class.run }.to change { WasteExemptionsEngine::TransientPerson.where(transient_registration_id: id).count }.from(people_count).to(0)
      end

      it "deletes its transient_registration_exemptions" do
        re_count = transient_registration.registration_exemptions.count

        expect { described_class.run }.to change { WasteExemptionsEngine::TransientRegistrationExemption.where(transient_registration_id: id).count }.from(re_count).to(0)
      end
    end

    context "when a transient_registration is newer than 30 days" do
      it "does not delete it" do
        expect { described_class.run }.not_to change { WasteExemptionsEngine::TransientRegistration.where(id: id).count }.from(1)
      end

      context "when there are more transient_registrations than the limit" do
        before do
          10.times { create(:new_charged_registration, created_at: 31.days.ago) }
        end

        it "deletes only up to the limit" do
          expect { described_class.run(limit: 1) }.to change { WasteExemptionsEngine::TransientRegistration.where(created_at: ...30.days.ago).count }.by(-1)
        end
      end
    end
  end
end
