# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaymentDetailsPresenter do
  subject(:presenter) { described_class.new(registration) }

  let(:orders) { [] }
  let(:payments) { [] }
  let(:registration) { create(:registration, account: build(:account, orders:, payments:)) }

  describe "#orders" do
    let(:order_a) { build(:order, :with_charge_detail, created_at: 5.days.ago) }
    let(:order_b) { build(:order, :with_charge_detail, created_at: 8.days.ago) }
    let(:order_c) { build(:order, :with_charge_detail, created_at: 2.days.ago) }
    let(:orders) { [order_a, order_b, order_c] }

    it { expect(presenter.orders).to eq [order_c, order_a, order_b] }
  end

  describe "#payments" do
    let(:payment_bank_transfer) do
      build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_BANK_TRANSFER,
                      payment_status: WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS,
                      date_time: 3.days.ago)
    end
    let(:payment_govpay) do
      build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY,
                      payment_status: WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS,
                      moto_payment: false,
                      date_time: 2.days.ago)
    end
    let(:payment_incomplete) do
      build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY,
                      payment_status: WasteExemptionsEngine::Payment::PAYMENT_STATUS_CREATED)
    end
    let(:refund) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND, created_at: 5.days.ago) }
    let(:payments) do
      [
        payment_bank_transfer,
        payment_govpay,
        payment_incomplete,
        refund
      ]
    end

    it { expect(presenter.payments).not_to include(refund) }

    it { expect(presenter.payments).not_to include(payment_incomplete) }

    it do
      expect(presenter.payments.pluck(:id)).to eq [
        payment_govpay.id,
        payment_bank_transfer.id
      ]
    end
  end

  describe "#refunds" do
    let(:refund_a) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND, created_at: 5.days.ago) }
    let(:refund_b) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND, created_at: 3.days.ago) }
    let(:refund_c) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND, created_at: 2.days.ago) }
    let(:non_refund_payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY) }
    let(:payments) { [refund_a, refund_b, refund_c, non_refund_payment] }

    it { expect(presenter.refunds).to eq [refund_c, refund_b, refund_a] }

    it { expect(presenter.refunds).not_to include non_refund_payment }
  end

  describe "#balance" do
    let(:account_balance) { Faker::Number.number(digits: 4) }

    before { allow(registration.account).to receive(:balance).and_return(account_balance) }

    it { expect(presenter.balance).to eq sprintf("£%.2f", (account_balance / 100.0).round(2)) }
  end

  describe "#format_date" do
    it { expect(presenter.format_date(DateTime.new(2024, 11, 19, 15, 45))).to eq "19/11/2024" }
  end

  describe "#order_exemption_codes" do
    let(:exemption_a) { build(:exemption, code: "U5") }
    let(:exemption_b) { build(:exemption, code: "U1") }
    let(:exemption_c) { build(:exemption, code: "T3") }
    let(:order) { build(:order, :with_charge_detail, exemptions: [exemption_a, exemption_b, exemption_c]) }

    it { expect(presenter.order_exemption_codes(order).split(",")).to eq [exemption_c.code, exemption_b.code, exemption_a.code] }
  end

  describe "#payment_type" do
    context "with a BACS payment" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_BANK_TRANSFER) }

      it { expect(presenter.payment_type(payment)).to eq I18n.t("shared.payment.payment_type.bank_transfer") }
    end

    context "with a missing card payment" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_MISSING_CARD_PAYMENT) }

      it { expect(presenter.payment_type(payment)).to eq I18n.t("shared.payment.payment_type.missing_card_payment") }
    end

    context "with a payment of type 'other_payment'" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_OTHER) }

      it { expect(presenter.payment_type(payment)).to eq I18n.t("shared.payment.payment_type.other_payment") }
    end

    context "with a non-MOTO Govpay payment" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY, moto_payment: false) }

      it { expect(presenter.payment_type(payment)).to eq I18n.t("shared.payment.payment_type.govpay_payment") }
    end

    context "with a MOTO Govpay payment" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY, moto_payment: true) }

      it { expect(presenter.payment_type(payment)).to eq I18n.t("shared.payment.payment_type.govpay_payment_moto") }
    end
  end
end
