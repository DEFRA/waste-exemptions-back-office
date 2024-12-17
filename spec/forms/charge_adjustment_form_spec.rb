# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChargeAdjustmentForm do
  let(:registration) { create(:registration) }
  let(:account) { registration.account }

  describe "#submit" do
    subject(:form) { described_class.new(account: account) }

    context "when params are valid" do
      let(:valid_params) do
        {
          adjustment_type: "increase",
          amount: "20.00",
          reason: "Additional exemptions"
        }
      end

      it "returns true" do
        expect(form.submit(valid_params)).to be true
      end
    end

    context "with invalid adjustment type" do
      it "returns false when type is blank" do
        params = { adjustment_type: "", amount: "20.00", reason: "Test" }
        expect(form.submit(params)).to be false
        expect(form.errors[:adjustment_type]).to include("Select whether you want to increase or decrease the charge")
      end

      it "returns false when type is invalid" do
        params = { adjustment_type: "invalid", amount: "20.00", reason: "Test" }
        expect(form.submit(params)).to be false
        expect(form.errors[:adjustment_type]).to include("Select whether you want to increase or decrease the charge")
      end
    end

    context "with invalid amount" do
      it "returns false when amount is zero" do
        params = { adjustment_type: "increase", amount: "0.00", reason: "Test" }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Amount must be greater than 0")
      end

      it "returns false when amount is negative" do
        params = { adjustment_type: "increase", amount: "-10.00", reason: "Test" }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Enter a valid price - there’s a mistake in that one")
      end

      it "returns false when amount has too many decimal places" do
        params = { adjustment_type: "increase", amount: "20.000", reason: "Test" }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Enter a valid price - there’s a mistake in that one")
      end

      it "returns false when amount is blank" do
        params = { adjustment_type: "increase", amount: "", reason: "Test" }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Enter an amount for the adjustment")
      end
    end

    context "with invalid reason" do
      it "returns false when reason is blank" do
        params = { adjustment_type: "increase", amount: "20.00", reason: "" }
        expect(form.submit(params)).to be false
        expect(form.errors[:reason]).to include("Enter a reason for the adjustment")
      end
    end
  end
end
