# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordRefundForm do
  let(:registration) { create(:registration) }
  let(:payment) do
    create(:payment,
           payment_type: "bank_transfer",
           payment_amount: 3000,
           payment_status: "success")
  end

  before do
    registration.account.payments << payment
    registration.account
  end

  describe "#submit" do
    subject(:form) { described_class.new }

    context "when params are valid" do
      let(:valid_params) do
        {
          amount: "20.00",
          comments: "Refund approved",
          payment_id: payment.id
        }
      end

      it "returns true" do
        expect(form.submit(valid_params)).to be true
      end

      it "calls RecordRefundService with the expected params" do
        allow(RecordRefundService).to receive(:run)

        form.submit(valid_params)

        expect(RecordRefundService).to have_received(:run).with(
          comments: "Refund approved",
          payment: payment,
          amount_in_pence: 2000
        )
      end

      context "when the amount is a decimal" do
        it "calls RecordRefundService with the expected params" do
          allow(RecordRefundService).to receive(:run)

          valid_params[:amount] = "20.12"
          form.submit(valid_params)

          expect(RecordRefundService).to have_received(:run).with(
            comments: "Refund approved",
            payment: payment,
            amount_in_pence: 2012
          )
        end
      end
    end

    context "with invalid amount" do
      it "returns false when amount exceeds balance" do
        params = { amount: "50.00", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Refund amount must not exceed maximum refund amount")
      end

      it "returns false when amount is zero" do
        params = { amount: "0.00", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Refund amount must be greater than zero")
      end

      it "returns false when amount is negative" do
        params = { amount: "-10.00", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount].first).to eq("Enter a valid price - there’s a mistake in that one")
      end

      it "returns false when amount is too high precision" do
        params = { amount: "20.000", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount].first).to eq("Enter a valid price - there’s a mistake in that one")
      end

      it "returns false when amount is blank" do
        params = { amount: "", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Enter the amount to refund")
      end

      it "returns false if amount is higher than the payment amount" do
        params = { amount: "35.00", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Refund amount must not exceed the maximum refund amount")
      end

      context "when there are previous refunds" do
        before do
          create(:payment,
                 payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND,
                 payment_amount: -1000,
                 associated_payment_id: payment.id)
        end

        it "returns false if amount exceeds the available refund amount" do
          params = { amount: "25.00", comments: "Refund", payment_id: payment.id }
          expect(form.submit(params)).to be false
          expect(form.errors[:amount]).to include("Refund amount must not exceed the maximum refund amount")
        end

        it "returns true if amount is within the available refund amount" do
          params = { amount: "15.00", comments: "Refund", payment_id: payment.id }
          expect(form.submit(params)).to be true
        end
      end
    end

    context "with invalid payment" do
      it "returns false when payment doesn't exist" do
        params = { amount: "20.00", comments: "Refund", payment_id: 999_999 }
        expect(form.submit(params)).to be false
        expect(form.errors[:payment]).to include("Payment to refund is missing")
      end
    end

    context "with invalid comments" do
      it "returns false when comments are blank" do
        params = { amount: "20.00", comments: "", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:comments]).to include("Enter a reason for the refund")
      end
    end
  end
end
