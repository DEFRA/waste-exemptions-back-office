# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RecordRefundService do
    subject(:service) { described_class.new }

    let(:registration) { create(:registration) }
    let(:account) { create(:account, registration: registration) }
    let(:comments) { "Refund due to overpayment" }
    let(:amount_in_pence) { 10_000 }

    describe "#run" do
      context "when the refund is processed successfully" do
        let(:payment) { create(:payment, account: account, payment_amount: 10_000) }

        it "creates a new refund payment record" do
          payment
          expect { service.run(comments: comments, payment: payment, amount_in_pence: amount_in_pence) }
            .to change(Payment, :count).by(1)
        end

        it "creates the refund with correct attributes" do
          service.run(comments: comments, payment: payment, amount_in_pence: amount_in_pence)

          refund = Payment.last
          expect(refund).to have_attributes(
            payment_type: Payment::PAYMENT_TYPE_REFUND,
            payment_amount: -10_000,
            payment_status: Payment::PAYMENT_STATUS_SUCCESS,
            account_id: payment.account_id,
            reference: "#{payment.reference}/REFUND",
            comments: comments,
            associated_payment_id: payment.id
          )
          expect(refund.payment_uuid).not_to be_nil
        end

        it "returns true" do
          result = service.run(comments: comments, payment: payment, amount_in_pence: amount_in_pence)
          expect(result).to be true
        end
      end

      context "when an error occurs" do
        let(:payment) { create(:payment, account: account, payment_amount: 10_000) }

        before do
          allow(Payment).to receive(:new).and_return(payment)
          allow(payment).to receive(:save!).and_raise(StandardError)
        end

        it "logs the error" do
          logger = instance_double(Logger)
          allow(logger).to receive(:error)
          allow(Rails).to receive(:logger).and_return(logger)
          service.run(comments: comments, payment: payment, amount_in_pence: amount_in_pence)

          expect(logger).to have_received(:error).with(/StandardError error processing refund for payment #{payment.id}/)
        end

        it "notifies Airbrake" do
          allow(Airbrake).to receive(:notify)
          service.run(comments: comments, payment: payment, amount_in_pence: amount_in_pence)

          expect(Airbrake).to have_received(:notify).with(
            instance_of(StandardError),
            message: "Error processing refund for payment ",
            payment_id: payment.id
          )
        end

        it "returns false" do
          result = service.run(comments: comments, payment: payment, amount_in_pence: amount_in_pence)
          expect(result).to be false
        end

        it "does not create a new payment record" do
          expect do
            service.run(comments: comments, payment: payment, amount_in_pence: amount_in_pence)
          end.not_to change(Payment, :count)
        end
      end
    end
  end
end
