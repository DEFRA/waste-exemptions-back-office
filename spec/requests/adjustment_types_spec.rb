# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Adjustment Types" do
  let(:user) { create(:user, :developer) }
  let(:registration) { create(:registration) }

  before do
    sign_in(user)
  end

  shared_examples "not permitted" do
    it { expect(response.code).to eq(WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE.to_s) }
    it { expect(response.location).to include("/pages/permission") }
  end

  describe "GET /registrations/:reference/adjustment_types/new" do
    context "when the user is signed in" do
      it "renders the new template" do
        get new_registration_adjustment_type_path(registration_reference: registration.reference)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end

      context "when the user does not have permission to access the page" do
        let(:user) { create(:user, :data_viewer) }

        before do
          get new_registration_adjustment_type_path(registration_reference: registration.reference)
        end

        it_behaves_like "not permitted"
      end
    end

    context "when the user is not signed in" do
      before { sign_out(user) }

      it "redirects to the sign-in page" do
        get new_registration_adjustment_type_path(registration_reference: registration.reference)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /registrations/:reference/adjustment_types" do
    let(:valid_params) do
      {
        adjustment_type_form: {
          adjustment_type: "increase"
        }
      }
    end

    context "when the user is signed in" do
      context "with valid params" do
        it "redirects to the new charge adjustment page" do
          post registration_adjustment_types_path(registration_reference: registration.reference), params: valid_params

          expect(response).to redirect_to(
            new_registration_charge_adjustment_path(
              registration_reference: registration.reference,
              adjustment_type: "increase"
            )
          )
        end
      end

      context "with invalid params" do
        let(:invalid_params) do
          {
            adjustment_type_form: {
              adjustment_type: ""
            }
          }
        end

        it "renders the new template" do
          post registration_adjustment_types_path(registration_reference: registration.reference), params: invalid_params

          expect(response).to render_template(:new)
        end
      end

      context "when the user does not have permission to access the page" do
        let(:user) { create(:user, :data_viewer) }

        before do
          post registration_adjustment_types_path(registration_reference: registration.reference), params: valid_params
        end

        it_behaves_like "not permitted"
      end
    end

    context "when the user is not signed in" do
      before { sign_out(user) }

      it "redirects to the sign-in page" do
        post registration_adjustment_types_path(registration_reference: registration.reference), params: valid_params

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
