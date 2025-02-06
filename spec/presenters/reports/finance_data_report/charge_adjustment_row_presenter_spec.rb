# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe ChargeAdjustmentRowPresenter do
      let(:charge_adjustment) { build(:charge_adjustment, amount: 1500) }
      let(:registration) { build(:registration, reference: "REG123", submitted_at: Time.zone.now) }
      let(:presenter) { described_class.new(registration: registration, secondary_object: charge_adjustment) }

      describe "#charge_type" do
        it "returns 'charge_adjust'" do
          expect(presenter.charge_type).to eq("charge_adjust")
        end
      end

      describe "#charge_amount" do
        it "returns the formatted charge amount" do
          expect(presenter.charge_amount).to eq("15")
        end
      end
    end
  end
end
