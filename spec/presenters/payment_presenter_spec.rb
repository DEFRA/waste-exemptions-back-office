# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaymentPresenter do
  subject(:presenter) { described_class.new(payment) }

  describe "#payment_type" do
    context "with a BACS payment" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_BANK_TRANSFER) }

      it { expect(presenter.payment_type).to eq I18n.t("shared.payment.payment_type.bank_transfer") }
    end

    context "with a missing card payment" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_MISSING_CARD_PAYMENT) }

      it { expect(presenter.payment_type).to eq I18n.t("shared.payment.payment_type.missing_card_payment") }
    end

    context "with a payment of type 'other_payment'" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_OTHER) }

      it { expect(presenter.payment_type).to eq I18n.t("shared.payment.payment_type.other_payment") }
    end

    context "with a non-MOTO Govpay payment" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY, moto_payment: false) }

      it { expect(presenter.payment_type).to eq I18n.t("shared.payment.payment_type.govpay_payment") }
    end

    context "with a MOTO Govpay payment" do
      let(:payment) { build(:payment, payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY, moto_payment: true) }

      it { expect(presenter.payment_type).to eq I18n.t("shared.payment.payment_type.govpay_payment_moto") }
    end
  end
end
