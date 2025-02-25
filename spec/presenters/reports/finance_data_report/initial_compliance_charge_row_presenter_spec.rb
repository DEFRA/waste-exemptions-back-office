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
      let(:presenter) { described_class.new(registration: registration, secondary_object: band_charge_detail, total: 1000) }

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

      describe "#exemption" do
        context "when there are no farmer exemptions" do
          it "returns exemption code(s)" do
            expect(presenter.exemption).to be_present
            order.exemptions.each do |exemption|
              expect(presenter.exemption).to include(exemption.code)
            end
          end
        end

        context "when there are farmer exemptions" do
          let(:bucket) { build(:bucket, :farmer_exemptions) }
          let(:order) { build(:order, :with_exemptions, :with_charge_detail, order_owner: account, bucket: bucket) }

          it "does not include farmer exemption code(s)" do
            farmer_exemption = order.exemptions.last
            bucket.exemptions << farmer_exemption

            expect(presenter.exemption).to be_present
            expect(presenter.exemption).not_to include(farmer_exemption.code)
          end
        end
      end

      describe "#balance" do
        it "returns the formatted balance amount" do
          expect(presenter.balance).to eq("20")
        end
      end
    end
  end
end
