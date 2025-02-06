# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe InitialComplianceChargeRowPresenter do
      let(:band) { build(:band, sequence: 2) }
      let(:band_charge_detail) { build(:band_charge_detail, initial_compliance_charge_amount: 1000, band: band) }
      let(:registration) { build(:registration, reference: "REG123", submitted_at: Time.zone.now) }
      let(:presenter) { described_class.new(registration: registration, secondary_object: band_charge_detail) }

      describe "#charge_type" do
        it "returns 'compliance_initial'" do
          expect(presenter.charge_type).to eq("compliance_initial")
        end
      end

      describe "#charge_amount" do
        it "returns the formatted charge amount" do
          expect(presenter.charge_amount).to eq("10")
        end
      end

      describe "#charge_band" do
        it "returns the band sequence" do
          expect(presenter.charge_band).to eq(2)
        end
      end
    end
  end
end
