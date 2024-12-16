# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Record Reversal Forms" do
  let(:user) { create(:user, :admin_agent) }
  let(:registration) { create(:registration) }
  let(:payment) do
    create(:payment,
           payment_type: "bank_transfer",
           payment_amount: 3000,
           payment_status: "success")
  end

  before do
    registration.account.payments << payment
    account = registration.account
    account.balance = payment.payment_amount
    account.save!
    sign_in(user)
  end

  describe "GET /registrations/:reference/record-reversal" do
    context "when the user is signed in" do
      it "renders the index template and returns a 200 status" do
        get registration_record_reversals_path(registration_reference: registration.reference)

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end

      it "displays the payment details in the table" do
        get registration_record_reversals_path(registration_reference: registration.reference)

        expect(response.body).to include("£30")
      end
    end

    context "when the user is not signed in" do
      before { sign_out(user) }

      it "redirects to the sign-in page" do
        get registration_record_reversals_path(registration_reference: registration.reference)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /registrations/:reference/record-reversal/:payment_id/new" do
    context "when the user is signed in" do
      it "renders the new template and returns a 200 status" do
        get new_registration_record_reversal_path(registration_reference: registration.reference, payment_id: payment.id)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end

      it "displays the amount to reverse" do
        get new_registration_record_reversal_path(registration_reference: registration.reference, payment_id: payment.id)

        expect(response.body).to include("£30")
      end
    end

    context "when the user is not signed in" do
      before { sign_out(user) }

      it "redirects to the sign-in page" do
        get new_registration_record_reversal_path(registration_reference: registration.reference, payment_id: payment.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when the payment doesn't exist" do
      it "redirects to the payment details page" do
        get new_registration_record_reversal_path(registration_reference: registration.reference, payment_id: "foo")

        expect(response).to redirect_to(registration_payment_details_path(registration_reference: registration.reference))
      end
    end
  end

  describe "POST /registrations/:reference/record-reversal" do
    let(:valid_params) do
      {
        record_reversal_form: {
          payment_id: payment.id,
          comments: "Payment recorded in error"
        }
      }
    end

    context "when the user is signed in" do
      context "with valid params" do
        it "creates a new reversal payment" do
          expect do
            post registration_record_reversals_path(registration_reference: registration.reference), params: valid_params
          end.to change(WasteExemptionsEngine::Payment, :count).by(1)
        end

        it "redirects to the payment details page" do
          post registration_record_reversals_path(registration_reference: registration.reference), params: valid_params

          expect(response).to redirect_to(registration_payment_details_path(registration_reference: registration.reference))
        end

        it "creates a reversal with the correct attributes" do
          post registration_record_reversals_path(registration_reference: registration.reference), params: valid_params

          reversal = WasteExemptionsEngine::Payment.last
          expect(reversal.payment_type).to eq("reversal")
          expect(reversal.payment_amount).to eq(-3000) # Amount in pence
          expect(reversal.payment_status).to eq("success")
          expect(reversal.comments).to eq("Payment recorded in error")
        end
      end

      context "with invalid params" do
        let(:invalid_params) do
          {
            record_reversal_form: {
              payment_id: payment.id,
              comments: "" # Comments are required for reversals
            }
          }
        end

        it "renders the new template" do
          post registration_record_reversals_path(registration_reference: registration.reference), params: invalid_params

          expect(response).to render_template(:new)
        end

        it "does not create a new payment" do
          expect do
            post registration_record_reversals_path(registration_reference: registration.reference), params: invalid_params
          end.not_to change(WasteExemptionsEngine::Payment, :count)
        end
      end
    end

    context "when the user is not signed in" do
      before { sign_out(user) }

      it "redirects to the sign-in page" do
        post registration_record_reversals_path(registration_reference: registration.reference), params: valid_params

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
