# frozen_string_literal: true

require "rails_helper"
require "zip"

RSpec.describe EaPublicFaceAreaDataLoadService, type: :service do
  describe ".run" do
    existing_code = "WSX" # this value is present in the fixture JSON file
    existing_area_id = "28" # this value is present in the fixture JSON file
    existing_name = "an area name" # this value is NOT present in the fixture JSON file

    # The service is heavy so run it once only
    before(:all) do # rubocop:disable RSpec/BeforeAfterAll
      WasteExemptionsEngine::EaPublicFaceArea.create!(
        area_id: existing_area_id,
        code: existing_code,
        name: existing_name,
        area: nil
      )
      described_class.run
    end

    let(:existing_area) { WasteExemptionsEngine::EaPublicFaceArea.find_by(code: existing_code) }

    it { expect(WasteExemptionsEngine::EaPublicFaceArea.count).to eq(14) }

    it "sets the expected attributes" do
      area = WasteExemptionsEngine::EaPublicFaceArea.first
      aggregate_failures do
        expect(area.area_id).to be_present
        expect(area.code).to be_present
        expect(area.name).to be_present
        expect(area.area).to be_present
      end
    end

    it "does not update the code" do
      expect(existing_area.reload.code).to eq existing_code
    end

    it "does not update the area_id" do
      expect(existing_area.reload.area_id).to eq existing_area_id
    end

    it "saves the area geometry" do
      expect(existing_area.reload.area).not_to be_nil
    end

    it "updates the area name" do
      expect(existing_area.reload.name).not_to eq existing_name
    end
  end
end
