# frozen_string_literal: true

require "rails_helper"

RSpec.describe AddPaymentForm, type: :model do

  subject(:form) { described_class.new(account) }

  let(:registration) { create(:registration, :with_active_exemptions) }
  let(:account) { create(:account, registration: registration) }

  let(:date) { 1.day.ago.to_date }
  let(:add_payment_form) do
    {
      payment_type: "bank_transfer",
      payment_amount: 93.26,
      payment_reference: "1234567890",
      date_day: date.day.to_s,
      date_month: date.month.to_s,
      date_year: date.year.to_s,
      comments: "test comments"
    }
  end

  shared_examples "form submission fails" do |attr|
    it "does not submit" do
      expect(form.submit(add_payment_form)).to be(false)
    end

    it "contains an error" do
      form.submit(add_payment_form)
      expect(form.errors).to include(attr)
    end

    it "does not contain any other errors" do
      form.submit(add_payment_form)
      expect(form.errors.count).to eq(1)
    end
  end

  describe "#submit" do
    context "when the form is not valid" do
      context "when the payment_type is invalid" do
        before { add_payment_form[:payment_type] = "foo" }

        it_behaves_like "form submission fails", :payment_type
      end

      context "when the date day is invalid" do
        before { add_payment_form[:date_day] = 99 }

        it_behaves_like "form submission fails", :payment_date
      end

      context "when the date month is invalid" do
        before { add_payment_form[:date_month] = 99 }

        it_behaves_like "form submission fails", :payment_date
      end

      context "when the date year is invalid" do
        before { add_payment_form[:date_year] = 9999 }

        it_behaves_like "form submission fails", :payment_date
      end

      context "when the payment_amount is invalid" do
        before { add_payment_form[:payment_amount] = "abc" }

        it_behaves_like "form submission fails", :payment_amount
      end

      context "when the payment_reference is nil" do
        before { add_payment_form[:payment_reference] = nil }

        it_behaves_like "form submission fails", :payment_reference
      end

      context "when the comments too long" do
        before do
          add_payment_form[:comments] = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nisi sem, efficitur et venenatis \
          sit amet, dapibus quis erat. Vestibulum velit ligula, luctus at commodo porttitor, viverra et orci. Orci varius natoque penatibus \
          et magnis dis parturient montes, nascetur ridiculus mus. Donec in lectus quis urna varius convallis a non metus. Duis leo ante, \
          porttitor in est eget, sodales pellentesque metus. Pellentesque ut viverra nisl. Suspendisse pulvinar efficitur odio at malesuada. \
          Aenean in sem vel leo placerat feugiat posuere in velit. Phasellus accumsan orci ipsum, non luctus tortor imperdiet in. Integer \
          ultricies congue lectus sed tristique. Maecenas lectus lectus, aliquam id vehicula eu, dignissim non erat. Donec euismod placerat \
          eros, nec finibus sem malesuada vitae. Praesent tristique sem auctor sapien pellentesque, vitae congue massa faucibus. Duis tincidunt \
          mauris a risus efficitur auctor. Fusce non ullamcorper urna, vel rhoncus erat."
        end

        it_behaves_like "form submission fails", :comments
      end
    end

    context "when the form is valid" do
      it "submits" do
        expect(form.submit(add_payment_form)).to be(true)
      end

      it "creates a new payment" do
        expect { form.submit(add_payment_form) }.to change(WasteExemptionsEngine::Payment, :count).by(1)
      end

      it "creates a new payment with the correct attributes" do
        form.submit(add_payment_form)

        payment = WasteExemptionsEngine::Payment.last
        expect(payment.payment_type).to eq("bank_transfer")
        expect(payment.payment_amount).to eq(9326)
        expect(payment.payment_status).to eq(WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS)
        expect(payment.date_time.to_date).to eq(date)
        expect(payment.payment_uuid).not_to be_nil
        expect(payment.reference).to eq("1234567890")
        expect(payment.account).to eq(account)
        expect(payment.comments).to eq("test comments")
      end
    end
  end
end
