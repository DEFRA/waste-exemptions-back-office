# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe SummaryRowPresenter do
      let(:site_address) { build(:address, :site_address, area: "Wessex") }
      let(:registration) do
        build(
          :registration,
          reference: "REG123",
          submitted_at: Time.zone.local(2025, 11, 27),
          on_a_farm: true,
          is_a_farmer: true,
          addresses: [site_address]
        )
      end
      let(:presenter) do
        described_class.new(
          registration: registration,
          charge_total_in_pence: charge_total_in_pence,
          balance_in_pence: balance_in_pence
        )
      end
      let(:charge_total_in_pence) { 274_400 }
      let(:balance_in_pence) { -274_400 }

      before do
        allow(registration).to receive(:state).and_return("active")
      end

      describe "#charge_type" do
        it "returns summary" do
          expect(presenter.charge_type).to eq("summary")
        end
      end

      describe "#charge_amount" do
        it "returns the formatted total charge amount" do
          expect(presenter.charge_amount).to eq("2744")
        end
      end

      describe "#balance" do
        it "returns the formatted current balance" do
          expect(presenter.balance).to eq("-2744")
        end
      end

      describe "#payment_status" do
        context "when balance is negative" do
          it "returns Unpaid" do
            expect(presenter.payment_status).to eq("Unpaid")
          end
        end

        context "when balance is zero" do
          let(:balance_in_pence) { 0 }

          it "returns Paid" do
            expect(presenter.payment_status).to eq("Paid")
          end
        end

        context "when balance is positive" do
          let(:balance_in_pence) { 100 }

          it "returns Overpaid" do
            expect(presenter.payment_status).to eq("Overpaid")
          end
        end
      end
    end
  end
end
