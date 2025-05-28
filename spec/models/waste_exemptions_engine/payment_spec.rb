# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Payment do
    describe "#total_refunded_amount" do
      let(:payment) { create(:payment, :success, payment_amount: 100, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }

      context "when there are no refunds for the payment" do
        it "returns 0" do
          expect(payment.total_refunded_amount).to eq(0)
        end
      end

      context "when there are refunds for the payment" do
        before do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_REFUND,
                 payment_amount: -30,
                 associated_payment_id: payment.id)
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_REFUND,
                 payment_amount: -20,
                 associated_payment_id: payment.id)
        end

        it "returns the sum of all refund amounts" do
          expect(payment.total_refunded_amount).to eq(50)
        end
      end
    end

    describe "#total_reversed_amount" do
      let(:payment) { create(:payment, :success, payment_amount: 100, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }

      context "when there are no reversals for the payment" do
        it "returns 0" do
          expect(payment.total_reversed_amount).to eq(0)
        end
      end

      context "when there are reversals for the payment" do
        before do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_REVERSAL,
                 payment_amount: -100,
                 associated_payment_id: payment.id)
        end

        it "returns the total reversed amount" do
          expect(payment.total_reversed_amount).to eq(100)
        end
      end
    end

    describe "#available_refund_amount" do
      let(:payment_amount) { 100 }
      let(:payment) { create(:payment, :success, payment_amount:, payment_type:) }

      context "when payment type is not refundable" do
        let(:payment_type) { Payment::PAYMENT_TYPE_REVERSAL }

        it "returns 0" do
          expect(payment.available_refund_amount).to eq(0)
        end
      end

      context "when payment type is refundable" do
        let(:account) { payment.account }
        let(:payment_type) { Payment::PAYMENT_TYPE_BANK_TRANSFER }

        context "when there are no previous refunds" do
          context "when payment amount is less than account balance" do
            before do
              allow(account).to receive(:balance).and_return(200)
            end

            it "returns the payment amount" do
              expect(payment.available_refund_amount).to eq(payment_amount)
            end
          end

          context "when payment amount is greater than account balance" do
            before do
              allow(account).to receive(:balance).and_return(50)
            end

            it "returns the account balance" do
              expect(payment.available_refund_amount).to eq(50)
            end
          end
        end

        context "when there are previous refunds" do
          before do
            create(:payment,
                   payment_type: Payment::PAYMENT_TYPE_REFUND,
                   payment_amount: -30,
                   associated_payment_id: payment.id)
          end

          context "when remaining payment amount is less than account balance" do
            before do
              allow(account).to receive(:balance).and_return(200)
            end

            it "returns the remaining payment amount" do
              expect(payment.available_refund_amount).to eq(70)
            end
          end

          context "when remaining payment amount is greater than account balance" do
            before do
              allow(account).to receive(:balance).and_return(40)
            end

            it "returns the account balance" do
              expect(payment.available_refund_amount).to eq(40)
            end
          end

          context "when the payment has been fully refunded" do
            before do
              create(:payment,
                     payment_type: Payment::PAYMENT_TYPE_REFUND,
                     payment_amount: -70,
                     associated_payment_id: payment.id)
            end

            it "returns 0" do
              expect(payment.available_refund_amount).to eq(0)
            end
          end
        end

        context "when there is an existing reversal" do
          before do
            create(:payment,
                   payment_type: Payment::PAYMENT_TYPE_REVERSAL,
                   payment_amount: -100,
                   associated_payment_id: payment.id)
          end

          it "returns 0" do
            expect(payment.available_refund_amount).to eq(0)
          end
        end
      end
    end

    describe "#available_for_refund?" do
      let(:payment_amount) { 100 }
      let(:payment) { create(:payment, :success, payment_amount:, payment_type:) }

      context "when payment type is not refundable" do
        let(:payment_type) { Payment::PAYMENT_TYPE_REVERSAL }

        it "returns false" do
          expect(payment.available_for_refund?).to be false
        end
      end

      context "when payment type is refundable" do
        let(:account) { payment.account }
        let(:payment_type) { Payment::PAYMENT_TYPE_BANK_TRANSFER }

        context "when there is available refund amount" do
          before do
            allow(account).to receive(:balance).and_return(200)
          end

          it "returns true" do
            expect(payment.available_for_refund?).to be true
          end
        end

        context "when there is no available refund amount" do
          before do
            create(:payment,
                   payment_type: Payment::PAYMENT_TYPE_REFUND,
                   payment_amount: -100,
                   associated_payment_id: payment.id)
          end

          it "returns false" do
            expect(payment.available_for_refund?).to be false
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
        let!(:bank_transfer) { create(:payment, :success, payment_amount: 100, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }
        let!(:govpay) { create(:payment, :success, payment_amount: 100, payment_type: Payment::PAYMENT_TYPE_GOVPAY) }
        let!(:refund) { create(:payment, :success, payment_type: Payment::PAYMENT_TYPE_REFUND) }
        let!(:fully_refunded_payment) { create(:payment, :success, payment_amount: 100, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }
        let!(:reversed_payment) { create(:payment, :success, payment_amount: 100, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }

        before do
          # refund the "fully_refunded_payment" so that it has no available refund amount
          create(:payment, :success, payment_amount: -100, payment_type: Payment::PAYMENT_TYPE_REFUND, associated_payment_id: fully_refunded_payment.id)
          # reverse the "reversed_payment" so that it has no available refund amount
          create(:payment, :success, payment_amount: -100, payment_type: Payment::PAYMENT_TYPE_REVERSAL, associated_payment_id: reversed_payment.id)
          # Make fully_refunded_payment have no available refund amount
          allow(bank_transfer).to receive(:available_refund_amount).and_return(100)
          allow(govpay).to receive(:available_refund_amount).and_return(100)
        end

        it "returns only successful payments with refundable payment types and positive available refund amount" do
          result = described_class.refundable

          expect(result).to include(bank_transfer, govpay)
          expect(result).not_to include(refund, fully_refunded_payment, reversed_payment)
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

      describe ".reverseable" do
        let!(:successful_bank_transfer) do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER,
                 payment_status: "success")
        end
        let!(:successful_govpay) do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_GOVPAY,
                 payment_status: "success")
        end
        let!(:failed_payment) do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER,
                 payment_status: "failed")
        end
        let!(:reversed_payment) do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER,
                 payment_status: "success")
        end
        let!(:reversal) do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_REVERSAL,
                 payment_status: "success",
                 associated_payment_id: reversed_payment.id)
        end

        it "includes successful bank transfer payments that haven't been reversed" do
          expect(described_class.reverseable).to include(successful_bank_transfer)
        end

        it "excludes govpay payments" do
          expect(described_class.reverseable).not_to include(successful_govpay)
        end

        it "excludes failed payments" do
          expect(described_class.reverseable).not_to include(failed_payment)
        end

        it "excludes payments that have already been reversed" do
          expect(described_class.reverseable).not_to include(reversed_payment)
        end

        it "excludes reversal payments themselves" do
          expect(described_class.reverseable).not_to include(reversal)
        end
      end
    end
  end
end
