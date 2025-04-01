# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe PaymentRowPresenter do
      let(:account) { build(:account, :with_payment) }
      let(:order) { build(:order, :with_exemptions, :with_charge_detail, order_owner: account) }

      let(:registration) { build(:registration, reference: "REG123", submitted_at: Time.zone.now, account: account) }
      let(:presenter) { described_class.new(registration: registration, secondary_object: account.payments.first, total: -3050) }

      describe "#payment_type" do
        it "returns payment type" do
          account.payments.first.update(payment_type: "bank_transfer")
          expect(presenter.payment_type).to eq("bank_transfer")
        end

        it "returns card when payment type is govpay_payment" do
          expect(presenter.payment_type).to eq("card")
        end

        it "returns card(moto) when payment type is govpay_payment and journey is assisted" do
          registration.update(assistance_mode: "full")
          expect(presenter.payment_type).to eq("card(moto)")
        end
      end

      describe "#reference" do
        it "returns payment reference" do
          expect(presenter.reference).to be_present
        end
      end

      describe "#payment_amount" do
        it "shows the positive amount when payment type is not refund or reversal" do
          account.payments.first.update(payment_type: "bank_transfer")
          expect(presenter.payment_amount).to eq("10")
        end

        it "shows the negative amount when payment type is refund" do
          account.payments.first.update(payment_type: "refund", payment_amount: -1000)
          expect(presenter.payment_amount).to eq("-10")
        end

        it "shows the negative amount when payment type is reversal" do
          account.payments.first.update(payment_type: "reversal", payment_amount: -1000)
          expect(presenter.payment_amount).to eq("-10")
        end
      end

      describe "#balance" do
        it "returns the formatted balance amount, calculated as the previous balance minus amount paid" do
          account.payments.first.update(payment_type: "bank_transfer")
          expect(presenter.balance).to eq("-20.50")
        end

        it "returns the formatted balance amount, calculated as the previous balance plus the amount refunded" do
          account.payments.first.update(payment_type: "refund", payment_amount: -1000)
          expect(presenter.balance).to eq("-40.50")
        end
      end

      describe "#refund_type" do
        let(:associated_payment) { create(:payment, associated_payment: account.payments.first) }

        before do
          account.payments << associated_payment
          account.payments.first.update(payment_type: "refund", associated_payment: associated_payment)
        end

        it "returns associated payment type" do
          associated_payment.update(payment_type: "bank_transfer")
          expect(presenter.refund_type).to eq("bank_transfer")
        end

        it "returns card when associated payment type is govpay_payment" do
          expect(presenter.refund_type).to eq("card")
        end

        it "returns card(moto) when associated payment type is govpay_payment and journey is assisted" do
          registration.update(assistance_mode: "full")
          expect(presenter.refund_type).to eq("card(moto)")
        end
      end
    end
  end
end
