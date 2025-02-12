# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe PaymentRowPresenter do
      let(:account) { build(:account, :with_payment) }
      let(:order) { build(:order, :with_exemptions, :with_charge_detail, order_owner: account) }

      let(:registration) { build(:registration, reference: "REG123", submitted_at: Time.zone.now, account: account) }
      let(:presenter) { described_class.new(registration: registration, secondary_object: account.payments.first) }

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
        it "returns formatted payment amount" do
          expect(presenter.payment_amount).to eq("10")
        end
      end

      describe "#balance" do
        it "returns formatted account balance" do
          expect(presenter.balance).to eq("10")
        end
      end
    end
  end
end
