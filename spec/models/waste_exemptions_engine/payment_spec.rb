# frozen_string_literal: true

require "rails_helper"
require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "payment")

module WasteExemptionsEngine
  RSpec.describe Payment do
    describe "#maximum_refund_amount" do
      let(:payment_amount) { 100 }
      let(:payment) { create(:payment, :success, payment_amount:) }

      context "when payment type is not refundable" do
        before do
          allow(payment).to receive(:payment_type).and_return(Payment::PAYMENT_TYPE_REVERSAL)
        end

        it "returns nil" do
          expect(payment.maximum_refund_amount).to be_nil
        end
      end

      context "when payment type is refundable" do
        let(:account) { instance_double(Account) }

        before do
          allow(payment).to receive_messages(payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER, account: account)
        end

        context "when payment amount is less than account balance" do
          before do
            allow(account).to receive(:balance).and_return(200)
          end

          it "returns the payment amount" do
            expect(payment.maximum_refund_amount).to eq(payment_amount)
          end
        end

        context "when payment amount is greater than account balance" do
          before do
            allow(account).to receive(:balance).and_return(50)
          end

          it "returns the account balance" do
            expect(payment.maximum_refund_amount).to eq(50)
          end
        end
      end
    end

    describe "scopes" do
      describe ".not_cancelled" do
        it "excludes cancelled payments" do
          cancelled_payment = create(:payment, :success, payment_status: Payment::PAYMENT_STATUS_CANCELLED)
          success_payment = create(:payment, :success, payment_status: Payment::PAYMENT_STATUS_SUCCESS)
          started_payment = create(:payment, :success, payment_status: Payment::PAYMENT_STATUS_STARTED)

          result = described_class.not_cancelled

          expect(result).to include(success_payment, started_payment)
          expect(result).not_to include(cancelled_payment)
        end
      end

      describe ".refunds_and_reversals" do
        let!(:refund) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_REFUND) }
        let!(:reversal) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_REVERSAL) }
        let!(:regular_payment) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }

        it "returns only refunds and reversals ordered by date" do
          result = described_class.refunds_and_reversals

          expect(result).to include(refund, reversal)
          expect(result).not_to include(regular_payment)
        end
      end

      describe ".excluding_refunds_and_reversals" do
        let!(:refund) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_REFUND) }
        let!(:reversal) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_REVERSAL) }
        let!(:regular_payment) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }

        it "excludes refunds and reversals" do
          result = described_class.excluding_refunds_and_reversals

          expect(result).to include(regular_payment)
          expect(result).not_to include(refund, reversal)
        end
      end

      describe ".refundable" do
        let!(:bank_transfer) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }
        let!(:govpay) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_GOVPAY) }
        let!(:refund) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_REFUND) }

        it "returns only successful payments with refundable payment types" do
          result = described_class.refundable

          expect(result).to include(bank_transfer, govpay)
          expect(result).not_to include(refund)
        end
      end

      describe ".successful_payments" do
        let!(:successful_payment) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }
        let!(:refund) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_REFUND) }

        it "returns successful payments excluding refunds and reversals" do
          result = described_class.successful_payments

          expect(result).to include(successful_payment)
          expect(result).not_to include(refund)
        end
      end
    end
  end
end
