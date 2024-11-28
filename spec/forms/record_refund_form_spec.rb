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
    end

    context "with invalid amount" do
      it "returns false when amount exceeds balance" do
        params = { amount: "50.00", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Refund amount must not exceed the payment amount")
      end

      it "returns false when amount is zero" do
        params = { amount: "0.00", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Refund amount must be greater than zero")
      end

      it "returns false when amount is negative" do
        params = { amount: "-10.00", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Enter a valid price - there’s a mistake in that one")
      end

      it "returns false when amount is too high precision" do
        params = { amount: "20.000", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Enter a valid price - there’s a mistake in that one")
      end

      it "returns false when amount is blank" do
        params = { amount: "", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Enter the amount to refund")
      end

      it "returns false if amount is higher than the balance" do
        params = { amount: "50.00", comments: "Refund", payment_id: payment.id }
        expect(form.submit(params)).to be false
        expect(form.errors[:amount]).to include("Refund amount must not exceed the account balance")
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
