# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChargeAdjustmentPresenter do
  subject(:presenter) { described_class.new(charge_adjustment) }

  let(:charge_adjustment) do
    build(:charge_adjustment,
          amount: 2000,
          adjustment_type: "increase",
          created_at: Time.zone.local(2024, 1, 15))
  end

  describe "#amount" do
    it "formats the amount in pence as pounds sterling with pound symbol" do
      expect(presenter.amount).to eq("£20.00")
    end
  end

  describe "#created_at" do
    it "formats the date in the expected format" do
      expect(presenter.created_at).to eq("15/01/2024")
    end
  end

  describe "#adjustment_type" do
    context "with a increase adjustment type" do
      it "returns the translated adjustment type" do
        expect(presenter.adjustment_type).to eq(
          I18n.t("shared.charge_adjustments.adjustment_type.increase")
        )
      end
    end

    context "with a decrease adjustment type" do
      before do
        charge_adjustment.adjustment_type = "decrease"
      end

      it "returns the translated adjustment type" do
        expect(presenter.adjustment_type).to eq(
          I18n.t("shared.charge_adjustments.adjustment_type.decrease")
        )
      end
    end
  end
end
