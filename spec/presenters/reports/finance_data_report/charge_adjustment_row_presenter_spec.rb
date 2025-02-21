# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe ChargeAdjustmentRowPresenter do
      let(:charge_adjustment) { build(:charge_adjustment, amount: 1550, adjustment_type: "decrease") }
      let(:registration) { build(:registration, reference: "REG123", submitted_at: Time.zone.now) }
      let(:presenter) { described_class.new(registration: registration, secondary_object: charge_adjustment, total: 3050) }

      describe "#charge_type" do
        it "returns 'charge_adjust'" do
          expect(presenter.charge_type).to eq("charge_adjust")
        end
      end

      describe "#charge_amount" do
        it "shows the negative amount when adjustment type is decrease" do
          expect(presenter.charge_amount).to eq("-15.50")
        end

        it "shows the positive amount when adjustment type is increase" do
          charge_adjustment.adjustment_type = "increase"
          expect(presenter.charge_amount).to eq("15.50")
        end
      end

      describe "#balance" do
        it "returns the formatted balance amount, calculated as the previous balance minus the charge adjustment amount" do
          expect(presenter.balance).to eq("15")
        end

        it "returns the formatted balance amount, calculated as the previous balance plus the charge adjustment amount" do
          charge_adjustment.adjustment_type = "increase"
          expect(presenter.balance).to eq("46")
        end
      end
    end
  end
end
