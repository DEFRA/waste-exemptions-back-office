# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe LegacyBulkLinearValidator, type: :model do
    it "is valid when both are false" do
      expect(Registration.new(is_legacy_bulk: false, is_linear: false)).to be_valid
    end

    it "is valid when only x is true" do
      expect(Registration.new(is_legacy_bulk: true, is_linear: false)).to be_valid
    end

    it "is valid when only y is true" do
      expect(Registration.new(is_legacy_bulk: false, is_linear: true)).to be_valid
    end

    it "is invalid when both are true" do
      model = Registration.new(is_legacy_bulk: true, is_linear: true)
      expect(model).not_to be_valid
      expect(model.errors[:base]).to include("is_legacy_bulk and is_linear cannot both be true")
    end
  end
end
