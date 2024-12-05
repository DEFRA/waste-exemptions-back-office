# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordReversalForm do
  let(:registration) { create(:registration) }
  let(:user) { create(:user) }
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
          comments: "Payment recorded in error",
          payment_id: payment.id,
          user: user
        }
      end

      before do
        form.user = user
      end

      it "returns true" do
        expect(form.submit(valid_params)).to be true
      end

      it "calls ReversePaymentService with the expected params" do
        allow(ReversePaymentService).to receive(:run)

        form.submit(valid_params)

        expect(ReversePaymentService).to have_received(:run).with(
          comments: "Payment recorded in error",
          payment: payment,
          user: user
        )
      end
    end

    context "with invalid payment" do
      let(:invalid_params) do
        {
          comments: "Payment recorded in error",
          payment_id: 999_999,
          user: user
        }
      end

      before do
        form.user = user
      end

      it "returns false when payment_id is missing" do
        invalid_params[:payment_id] = nil
        expect(form.submit(invalid_params)).to be false
        expect(form.errors[:payment_id]).to include("can't be blank")
      end

      it "returns false when payment doesn't exist" do
        expect(form.submit(invalid_params)).to be false
      end
    end

    context "with invalid comments" do
      let(:invalid_params) do
        {
          comments: "",
          payment_id: payment.id,
          user: user
        }
      end

      before do
        form.user = user
      end

      it "returns false when comments are blank" do
        expect(form.submit(invalid_params)).to be false
        expect(form.errors[:comments]).to include(
          I18n.t(".record_reversals.create.form.errors.reason_missing")
        )
      end

      it "returns false when comments are nil" do
        invalid_params[:comments] = nil
        expect(form.submit(invalid_params)).to be false
        expect(form.errors[:comments]).to include(
          I18n.t(".record_reversals.create.form.errors.reason_missing")
        )
      end
    end

    context "with missing user" do
      let(:valid_params) do
        {
          comments: "Payment recorded in error",
          payment_id: payment.id
        }
      end

      it "passes nil user to the service" do
        allow(ReversePaymentService).to receive(:run)

        form.submit(valid_params)

        expect(ReversePaymentService).to have_received(:run).with(
          comments: "Payment recorded in error",
          payment: payment,
          user: nil
        )
      end
    end
  end
end
