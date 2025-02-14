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
          expect(presenter.payment_type).to eq("govpay_payment")
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
