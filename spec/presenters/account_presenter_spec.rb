# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccountPresenter do
  subject(:presenter) { described_class.new(account) }

  describe "#balance" do
    let(:balance) { 123_45 }

    # balance is a method on account, not an attribute, so we cannot
    # simply set it to a numerical value when building the account
    before { allow(account).to receive(:balance).and_return(balance) unless account.nil? }

    context "when account is present" do
      let(:account) { build(:account) }

      it { expect(presenter.balance).to eq "£123.45" }
    end

    context "when account is not present" do
      let(:account) { nil }

      it { expect(presenter.balance).to be_nil }
    end
  end

  describe "#successful_payments" do

    context "when account is present" do
      let(:account) { create(:account, payments: build_list(:payment, 2, :success)) }

      it { expect(presenter.successful_payments.length).to eq(2) }
      it { expect(presenter.successful_payments).to all(be_an(PaymentPresenter)) }
    end

    context "when account is not present" do
      let(:account) { nil }

      it { expect(presenter.successful_payments).to be_empty }
    end
  end

  describe "#refunds_and_reversals" do
    context "when account is present" do
      let(:refund) { build(:payment, :success, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND) }
      let(:reversal) { build(:payment, :success, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REVERSAL) }
      let(:account) { create(:account, payments: [refund, reversal]) }

      it { expect(presenter.refunds_and_reversals.length).to eq(2) }
      it { expect(presenter.refunds_and_reversals).to all(be_an(PaymentPresenter)) }
    end

    context "when account is not present" do
      let(:account) { nil }

      it { expect(presenter.refunds_and_reversals).to be_empty }
    end
  end

  describe "#sorted_orders" do
    context "when account is present" do
      let(:account) { create(:account, orders: build_list(:order, 2)) }

      it { expect(presenter.sorted_orders.length).to eq(2) }
      it { expect(presenter.sorted_orders).to all(be_an(OrderPresenter)) }
    end

    context "when account is not present" do
      let(:account) { nil }

      it { expect(presenter.sorted_orders).to be_empty }
    end
  end

  describe "#charge_adjustments" do
    context "when account is present" do
      let(:account) { create(:account, charge_adjustments: build_list(:charge_adjustment, 2)) }

      it { expect(presenter.charge_adjustments.length).to eq(2) }
      it { expect(presenter.charge_adjustments).to all(be_an(ChargeAdjustmentPresenter)) }
    end

    context "when account is not present" do
      let(:account) { nil }

      it { expect(presenter.charge_adjustments).to be_empty }
    end
  end
end
