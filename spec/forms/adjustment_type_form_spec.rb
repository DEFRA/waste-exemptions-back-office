# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdjustmentTypeForm do
  describe "#submit" do
    subject(:form) { described_class.new }

    context "when params are valid" do
      let(:valid_params) do
        {
          adjustment_type: "increase"
        }
      end

      it "returns true" do
        expect(form.submit(valid_params)).to be true
      end
    end

    context "with invalid adjustment type" do
      invalid_types = ["", nil, "invalid"].freeze
      invalid_types.each do |type|
        it "returns false with an invalid type" do
          params = { adjustment_type: type }
          expect(form.submit(params)).to be false
          expect(form.errors[:adjustment_type]).to include("Select whether you want to increase or decrease the charge")
        end
      end
    end

    context "when submitting each valid type" do
      it "returns true for increase" do
        params = { adjustment_type: "increase" }
        expect(form.submit(params)).to be true
      end

      it "returns true for decrease" do
        params = { adjustment_type: "decrease" }
        expect(form.submit(params)).to be true
      end
    end
  end

  describe "constants" do
    it "defines the correct adjustment types" do
      expect(described_class::TYPES).to eq(%w[increase decrease])
    end
  end
end
