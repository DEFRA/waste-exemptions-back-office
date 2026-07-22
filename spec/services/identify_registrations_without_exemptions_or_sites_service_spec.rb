# frozen_string_literal: true

require "rails_helper"

RSpec.describe IdentifyRegistrationsWithoutExemptionsOrSitesService do
  subject(:service) { described_class }

  let(:registration_without_exemptions) { create(:registration, registration_exemptions: []) }
  let(:registration_without_sites) do
    create(:registration, :with_active_exemptions,
           addresses: [build(:address, :operator_address), build(:address, :contact_address)])
  end
  let(:complete_registration) { create(:registration) }
  let(:placeholder_registration) { create(:registration, registration_exemptions: [], placeholder: true) }

  describe ".run" do
    def flagged_ids
      service.run.pluck("ID")
    end

    it "includes a registration with no exemptions" do
      registration_without_exemptions
      expect(flagged_ids).to include(registration_without_exemptions.id)
    end

    it "includes a registration with no sites" do
      registration_without_sites
      expect(flagged_ids).to include(registration_without_sites.id)
    end

    it "excludes a registration that has both exemptions and sites" do
      complete_registration
      expect(flagged_ids).not_to include(complete_registration.id)
    end

    it "excludes placeholder registrations" do
      placeholder_registration
      expect(flagged_ids).not_to include(placeholder_registration.id)
    end

    it "reports the counts and no_exemptions status for a registration missing exemptions" do
      registration_without_exemptions
      row = service.run.find { |result| result["ID"] == registration_without_exemptions.id }
      expect(row).to include("Status" => "no_exemptions")
      expect(row["Exemptions"].to_i).to eq(0)
      expect(row["Sites"].to_i).to eq(1)
    end

    it "reports the derived registration state for a flagged registration that has exemptions" do
      registration_without_sites
      row = service.run.find { |result| result["ID"] == registration_without_sites.id }
      expect(row).to include("Status" => "active")
      expect(row["Sites"].to_i).to eq(0)
    end
  end
end
