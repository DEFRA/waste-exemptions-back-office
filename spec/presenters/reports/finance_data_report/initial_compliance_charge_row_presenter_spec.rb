# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe InitialComplianceChargeRowPresenter do
      let(:account) { build(:account) }
      let(:order) { build(:order, :with_exemptions, :with_charge_detail, order_owner: account) }

      let(:band_charge_detail) do
        band_charge_detail = order.charge_detail.band_charge_details.first
        band_charge_detail.initial_compliance_charge_amount = 1000
        band_charge_detail.band.sequence = 2
        band_charge_detail
      end

      let(:registration) { build(:registration, reference: "REG123", submitted_at: Time.zone.now, account: account) }
      let(:presenter) { described_class.new(registration: registration, secondary_object: band_charge_detail, total: -1000) }

      describe "#charge_type" do
        it "returns 'compliance_initial'" do
          expect(presenter.charge_type).to eq("compliance_initial")
        end
      end

      describe "#charge_amount_in_pence" do
        context "when registration is single site" do
          it "returns the formatted charge amount" do
            expect(presenter.charge_amount_in_pence).to eq(1000)
          end
        end

        context "when registration is multisite" do
          let(:registration) { build(:registration, :multisite, reference: "REG123", submitted_at: Time.zone.now, account: account) }
          let(:site_address) { build(:address, registration: registration) }
          let(:presenter) { described_class.new(registration: registration, secondary_object: band_charge_detail, site_address: site_address, total: -1000) }

          before do
            allow(order.charge_detail).to receive(:site_count).and_return(2)
          end

          it "returns the formatted charge amount divided by site count" do
            expect(presenter.charge_amount_in_pence).to eq(500)
          end
        end
      end
    end
  end
end
