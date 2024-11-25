# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Adjustment Types" do
  let(:user) { create(:user, :super_agent) }
  let(:registration) { create(:registration) }

  before do
    sign_in(user)
  end

  describe "GET /registrations/:reference/adjustment_types/new" do
    context "when the user is signed in" do
      it "renders the new template" do
        get new_registration_adjustment_type_path(registration_reference: registration.reference)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
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
