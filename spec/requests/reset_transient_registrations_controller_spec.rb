# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResetTransientRegistrationsController do
  let(:registration) { create(:registration) }

  describe "GET #new" do
    context "when the user is a developer" do
      let(:user) { create(:user, role: :developer) }

      before { sign_in(user) }

      it "responds with success" do
        get reset_transient_registrations_form_path(id: registration.reference)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is not a developer" do
      let(:user) { create(:user, role: :customer_service_adviser) }  # Change role as needed for testing

      before { sign_in(user) }

      it "redirects to the permission denied page" do
        get reset_transient_registrations_form_path(id: registration.reference)
        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "post #update" do
    context "when the user is a developer" do
      let(:user) { create(:user, role: :developer) }

      before { sign_in(user) }

      context "when there are transient registrations associated with the registration reference" do
        before do
          create(:renewing_registration, reference: registration.reference)
          create(:back_office_edit_registration, reference: registration.reference)
        end

        it "redirects to the registration page with a successful redirection status code" do
          post reset_transient_registrations_path(id: registration.reference)
          successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE.to_s
          expect(response.code).to eq(successful_redirection)
          expect(response).to redirect_to(registration_path(reference: registration.reference))
        end
      end

      context "when there are no transient registrations associated with the registration reference" do
        it "redirects to the registration page with an unsuccessful redirection status code" do
          post reset_transient_registrations_path(id: registration.reference)
          unsuccessful_redirection = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE.to_s
          expect(response.code).to eq(unsuccessful_redirection)
          expect(response).to redirect_to(registration_path(reference: registration.reference))
        end
      end
    end

    context "when the user is not a developer" do
      let(:user) { create(:user, role: :customer_service_adviser) }  # Change role as needed for testing

      before { sign_in(user) }

      it "redirects to the permission denied page" do
        post reset_transient_registrations_path(id: registration.reference)
        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
