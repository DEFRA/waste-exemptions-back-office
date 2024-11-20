# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ReversePaymentService do
    subject(:service) { described_class.new }
    let(:registration) { create(:registration) }
    let(:account) { create(:account, registration: registration) }
    let(:comments) { "Payment recorded in error" }
    let(:user) { create(:user, email: "test@example.com") }

    describe "#run" do
      context "when the reversal is processed successfully" do
        let(:payment) do
          create(:payment, account: account,
                 payment_amount: 10_000,
                 payment_status: Payment::PAYMENT_STATUS_SUCCESS)
        end

        before do
          payment
        end


        it "creates a new reversal payment record" do
          expect { service.run(comments: comments, payment: payment, user: user) }
            .to change(Payment, :count).by(1)
        end

        it "creates the reversal with correct attributes" do
          service.run(comments: comments, payment: payment, user: user)

          reversal = Payment.where(associated_payment: payment).first

          expect(reversal).to have_attributes(
            payment_type: Payment::PAYMENT_TYPE_REVERSAL,
            payment_amount: -10_000,
            payment_status: Payment::PAYMENT_STATUS_SUCCESS,
            account_id: payment.account_id,
            reference: "#{payment.reference}/REVERSAL",
            comments: comments,
            created_by: user.email
          )
          expect(reversal.payment_uuid).not_to be_nil
        end

        it "updates the account balance" do
          original_balance = account.balance

          service.run(comments: comments, payment: payment, user: user)

          expect(account.reload.balance).to eq(original_balance - payment.payment_amount)
        end

        it "returns true" do
          result = service.run(comments: comments, payment: payment, user: user)
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

          service.run(comments: comments, payment: payment, user: user)

          expect(logger).to have_received(:error).with(/StandardError error processing reversal for payment #{payment.id}/)
        end

        it "notifies Airbrake" do
          allow(Airbrake).to receive(:notify)
          service.run(comments: comments, payment: payment, user: user)

          expect(Airbrake).to have_received(:notify).with(
            instance_of(StandardError),
            message: "Error processing reversal for payment ",
            payment_id: payment.id
          )
        end

        it "returns false" do
          result = service.run(comments: comments, payment: payment, user: user)
          expect(result).to be false
        end

        it "does not create a new payment record" do
          expect do
            service.run(comments: comments, payment: payment, user: user)
          end.not_to change(Payment, :count)
        end
      end
    end
  end
end
