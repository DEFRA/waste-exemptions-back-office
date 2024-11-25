# frozen_string_literal: true

RSpec.describe AdjustmentTypeForm, type: :model do
  subject(:form) { described_class.new }

  describe "validations" do
    it { is_expected.to validate_presence_of(:adjustment_type) }

    it "validates inclusion of adjustment_type in TYPES" do
      is_expected.to validate_inclusion_of(:adjustment_type).in_array(AdjustmentTypeForm::TYPES)
    end
  end

  describe "#submit" do
    context "with valid params" do
      let(:valid_params) { { adjustment_type: "increase" } }

      it "returns true" do
        expect(form.submit(valid_params)).to be true
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { adjustment_type: "invalid" } }

      it "returns false" do
        expect(form.submit(invalid_params)).to be false
      end
    end
  end
end
