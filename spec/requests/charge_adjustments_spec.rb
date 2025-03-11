# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Charge Adjustments" do
  let(:user) { create(:user, :developer) }
  let(:registration) { create(:registration) }

  before do
    sign_in(user)
  end

  shared_examples "not permitted" do
    it { expect(response.code).to eq(WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE.to_s) }
    it { expect(response.location).to include("/pages/permission") }
  end

  describe "GET /registrations/:reference/charge-adjustment/new" do
    context "when the user is signed in" do
      it "renders the new template for increase" do
        get new_registration_charge_adjustment_path(
          registration_reference: registration.reference,
          adjustment_type: "increase"
        )

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Increase the charge")
      end

      it "renders the new template for decrease" do
        get new_registration_charge_adjustment_path(
          registration_reference: registration.reference,
          adjustment_type: "decrease"
        )

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Decrease the charge")
      end

      it "redirects when no adjustment type" do
        get new_registration_charge_adjustment_path(
          registration_reference: registration.reference
        )

        expect(response).to redirect_to(new_registration_adjustment_type_path)
      end

      context "when the user does not have permission to access the page" do
        let(:user) { create(:user, :data_viewer) }

        before do
          get new_registration_charge_adjustment_path(
            registration_reference: registration.reference,
            adjustment_type: "increase"
          )
        end

        it_behaves_like "not permitted"
      end
    end

    context "when the user is not signed in" do
      before { sign_out(user) }

      it "redirects to the sign-in page" do
        get new_registration_charge_adjustment_path(
          registration_reference: registration.reference,
          adjustment_type: "increase"
        )

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /registrations/:reference/charge-adjustment" do
    let(:valid_params) do
      {
        charge_adjustment_form: {
          adjustment_type: "increase",
          amount: "30.00",
          reason: "Additional exemptions added"
        }
      }
    end

    context "when the user is signed in" do
      context "with valid params" do
        it "creates a new charge adjustment" do
          expect do
            post registration_charge_adjustments_path(registration_reference: registration.reference), params: valid_params
          end.to change(WasteExemptionsEngine::ChargeAdjustment, :count).by(1)
        end

        it "redirects to the payment details page" do
          post registration_charge_adjustments_path(registration_reference: registration.reference), params: valid_params

          expect(response).to redirect_to(registration_payment_details_path(registration_reference: registration.reference))
        end

        it "creates an adjustment with the correct attributes" do
          post registration_charge_adjustments_path(registration_reference: registration.reference), params: valid_params

          adjustment = WasteExemptionsEngine::ChargeAdjustment.last
          expect(adjustment.adjustment_type).to eq("increase")
          expect(adjustment.amount).to eq(3000) # Amount in pence
          expect(adjustment.reason).to eq("Additional exemptions added")
        end

        it "triggers the SendRegistrationConfirmationWhenBalanceFullyPaidJob job" do
          allow(SendRegistrationConfirmationWhenBalanceFullyPaidJob).to receive(:perform_later)
          post registration_charge_adjustments_path(registration_reference: registration.reference), params: valid_params

          expect(SendRegistrationConfirmationWhenBalanceFullyPaidJob).to have_received(:perform_later).with(reference: registration.reference)
        end
      end

      context "with invalid params" do
        let(:invalid_params) do
          {
            charge_adjustment_form: {
              adjustment_type: "increase",
              amount: "",
              reason: ""
            }
          }
        end

        it "renders the new template" do
          post registration_charge_adjustments_path(registration_reference: registration.reference), params: invalid_params

          expect(response).to render_template(:new)
        end

        it "does not create a charge adjustment" do
          expect do
            post registration_charge_adjustments_path(registration_reference: registration.reference), params: invalid_params
          end.not_to change(WasteExemptionsEngine::ChargeAdjustment, :count)
        end
      end

      context "when the user does not have permission to access the page" do
        let(:user) { create(:user, :data_viewer) }

        before do
          post registration_charge_adjustments_path(registration_reference: registration.reference), params: valid_params
        end

        it_behaves_like "not permitted"
      end
    end

    context "when the user is not signed in" do
      before { sign_out(user) }

      it "redirects to the sign-in page" do
        post registration_charge_adjustments_path(registration_reference: registration.reference), params: valid_params

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
