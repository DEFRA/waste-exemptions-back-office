# frozen_string_literal: true
require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Payment do
    let(:registration) { create(:registration) }
    let(:account) { create(:account, registration:) }

    describe "#successful_payments" do
      let(:successful_payments_scope) { instance_double(ActiveRecord::Relation) }

      it "calls successful_payments on the payments association" do
        allow(account.payments).to receive(:successful_payments).and_return(successful_payments_scope)
        account.successful_payments
        expect(account.payments).to have_received(:successful_payments)
      end

      it "returns the successful_payments scope" do
        allow(account.payments).to receive(:successful_payments).and_return(successful_payments_scope)
        expect(account.successful_payments).to eq(successful_payments_scope)
      end
    end

    describe "#refunds_and_reversals" do
      let(:refunds_scope) { instance_double(ActiveRecord::Relation) }

      it "calls refunds_and_reversals on the payments association" do
        allow(account.payments).to receive(:refunds_and_reversals).and_return(refunds_scope)
        account.refunds_and_reversals
        expect(account.payments).to have_received(:refunds_and_reversals)
      end

      it "returns the refunds_and_reversals scope" do
        allow(account.payments).to receive(:refunds_and_reversals).and_return(refunds_scope)
        expect(account.refunds_and_reversals).to eq(refunds_scope)
      end
    end

    describe "#maximum_refund_amount" do
      context "when payment type is not refundable" do
        let(:reversal_payment) { create(:payment, payment_type: Payment::PAYMENT_TYPE_REVERSAL, account:) }

        it "returns nil" do
          expect(reversal_payment.maximum_refund_amount).to be_nil
        end
      end

      context "when payment type is refundable" do
        let(:payment_amount) { 100 }
        let(:refundable_payment) do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER,
                 payment_amount: payment_amount,
                 account:)
        end

        context "when payment amount is less than account balance" do
          before do
            allow(account).to receive(:balance).and_return(200)
          end

          it "returns the payment amount" do
            expect(refundable_payment.maximum_refund_amount).to eq(payment_amount)
          end
        end

        context "when payment amount is greater than account balance" do
          before do
            allow(account).to receive(:balance).and_return(50)
          end

          it "returns the account balance" do
            expect(refundable_payment.maximum_refund_amount).to eq(50)
          end
        end
      end
    end

    describe ".reverseable" do
      let!(:successful_bank_transfer) do
        create(:payment,
               payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER,
               payment_status: "success",
               account:)
      end
      let!(:successful_govpay) do
        create(:payment,
               payment_type: Payment::PAYMENT_TYPE_GOVPAY,
               payment_status: "success",
               account:)
      end
      let!(:failed_payment) do
        create(:payment,
               payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER,
               payment_status: "failed",
               account:)
      end
      let!(:reversed_payment) do
        create(:payment,
               payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER,
               payment_status: "success",
               account:)
      end
      let!(:reversal) do
        create(:payment,
               payment_type: Payment::PAYMENT_TYPE_REVERSAL,
               payment_status: "success",
               associated_payment_id: reversed_payment.id,
               account:)
      end

      it "includes successful bank transfer payments that haven't been reversed" do
        expect(Payment.reverseable).to include(successful_bank_transfer)
      end

      it "excludes govpay payments" do
        expect(Payment.reverseable).not_to include(successful_govpay)
      end

      it "excludes failed payments" do
        expect(Payment.reverseable).not_to include(failed_payment)
      end

      it "excludes payments that have already been reversed" do
        expect(Payment.reverseable).not_to include(reversed_payment)
      end

      it "excludes reversal payments themselves" do
        expect(Payment.reverseable).not_to include(reversal)
      end
    end
  end
end
