# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Add Payment Forms" do
  let(:form) { AddPaymentForm.new }
  let(:user) { create(:user, :developer) }
  let(:registration) { create(:registration) }
  let(:account) { create(:account, registration: registration) }

  before do
    account
    sign_in(user)
  end

  shared_examples "not permitted" do
    it { expect(response.code).to eq(WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE.to_s) }
    it { expect(response.location).to include("/pages/permission") }
  end

  shared_examples "payment not added" do |err_message|
    it "responds with a 200 status code" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the same template" do
      expect(response).to render_template("payments/new")
    end

    it "includes the expected error message" do
      expect(response.body).to include err_message
    end

    it "does not create payment record" do
      expect(WasteExemptionsEngine::Payment.count).to eq 0
    end
  end

  describe "GET /registrations/:registration_reference/payments" do

    before { get registration_add_payment_form_path(registration.reference) }

    context "when the user does not have permission to access the page" do
      let(:user) { create(:user, :data_viewer) }

      it_behaves_like "not permitted"
    end

    context "when the user has permission to access the page" do
      let(:user) { create(:user, :developer) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template("payments/new") }
    end
  end

  describe "POST /registrations/:registration_reference/payments" do
    let(:add_payment_form) do
      {
        payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_BANK_TRANSFER,
        payment_amount: 138.23,
        date_day: 1.day.ago.day,
        date_month: 1.day.ago.month,
        date_year: 1.day.ago.year,
        payment_reference: "123456",
        comments: "A comment"
      }
    end

    let(:request_body) { { add_payment_form: add_payment_form } }

    context "when the user does not have permission to access the page" do
      let(:user) { create(:user, :data_viewer) }

      before do
        post registration_add_payment_form_path(registration.reference), params: request_body
      end

      it_behaves_like "not permitted"
    end

    context "when submitted data is invalid" do
      context "when the payment_type is not set" do
        before do
          add_payment_form[:payment_type] = nil
          post registration_add_payment_form_path(registration.reference), params: request_body
        end

        it_behaves_like "payment not added", I18n.t("payments.errors.payment_type_invalid")
      end

      context "when the payment_amount is not set" do
        before do
          add_payment_form[:payment_amount] = nil
          post registration_add_payment_form_path(registration.reference), params: request_body
        end

        it_behaves_like "payment not added", I18n.t("payments.errors.payment_amount_blank")
      end

      context "when the payment_date is invalid" do
        before do
          add_payment_form[:date_year] = nil
          post registration_add_payment_form_path(registration.reference), params: request_body
        end

        it_behaves_like "payment not added", I18n.t("payments.errors.date_invalid")
      end

      context "when the payment_date is not current or in the past" do
        before do
          payment_date = 2.weeks.from_now
          add_payment_form[:date_day] = payment_date.day
          add_payment_form[:date_month] = payment_date.month
          add_payment_form[:date_year] = payment_date.year
          post registration_add_payment_form_path(registration.reference), params: request_body
        end

        it_behaves_like "payment not added", I18n.t("payments.errors.date_not_current_or_past")
      end

      context "when the payment_reference is not set" do
        before do
          add_payment_form[:payment_reference] = nil
          post registration_add_payment_form_path(registration.reference), params: request_body
        end

        it_behaves_like "payment not added", I18n.t("payments.errors.payment_reference_blank")
      end
    end

    context "when submitted data is valid" do
      before do
        allow(SendRegistrationConfirmationWhenBalanceFullyPaidJob).to receive(:perform_later)
        post registration_add_payment_form_path(registration.reference), params: request_body
      end

      it "responds with a successful redirect status code" do
        expect(response.code).to eq WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE.to_s
      end

      it "creates a payment record" do
        expect(WasteExemptionsEngine::Payment.count).to eq 1
      end

      it "creates a new payment with the correct attributes" do
        payment = WasteExemptionsEngine::Payment.last

        aggregate_failures "payment attributes" do
          expect(payment.payment_type).to eq(add_payment_form[:payment_type])
          expect(payment.payment_amount).to eq(WasteExemptionsEngine::CurrencyConversionService.convert_pounds_to_pence(add_payment_form[:payment_amount]))
          expect(payment.payment_status).to eq(WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS)
          expect(payment.date_time.day).to eq(add_payment_form[:date_day])
          expect(payment.date_time.month).to eq(add_payment_form[:date_month])
          expect(payment.date_time.year).to eq(add_payment_form[:date_year])
          expect(payment.payment_uuid).not_to be_nil
          expect(payment.reference).to eq(add_payment_form[:payment_reference])
          expect(payment.account).to eq(account)
          expect(payment.comments).to eq(add_payment_form[:comments])
        end
      end

      it "redirects to registration page" do
        expect(response.location).to include("registrations/#{registration.reference}/payment_details")
      end

      it "triggers the SendRegistrationConfirmationWhenBalanceFullyPaidJob job" do
        expect(SendRegistrationConfirmationWhenBalanceFullyPaidJob).to have_received(:perform_later).with(reference: registration.reference)
      end
    end

  end
end
