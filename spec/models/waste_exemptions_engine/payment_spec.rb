# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Payment do
    let(:registration) { create(:registration) }
    let(:account) { create(:account, registration:) }

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
  end
end
