# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Permit applications" do
  let(:user) { create(:user, :developer) }
  let(:registration) { create(:registration, :with_active_exemptions) }
  let(:marked_registration) { create(:registration, :with_active_exemptions, :permit_application_in_progress) }
  let(:valid_params) do
    { permit_application_form: { permit_application_number: "EPR/XY9876ZZ/A001", permit_application_status: "duly_made" } }
  end

  before { sign_in(user) }

  shared_examples "not permitted" do
    it { expect(response.code).to eq(WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE.to_s) }
    it { expect(response.location).to include("/pages/permission") }
  end

  describe "GET /registrations/:reference/permit-application/new" do
    context "when the registration is active and not marked" do
      before { get new_registration_permit_application_path(registration.reference) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include("Add details of the permit application") }
    end

    context "when the user is a service manager" do
      let(:user) { create(:user, :service_manager) }

      before { get new_registration_permit_application_path(registration.reference) }

      it { expect(response).to have_http_status(:ok) }
    end

    context "when the registration is already marked" do
      before { get new_registration_permit_application_path(marked_registration.reference) }

      it { expect(response).to redirect_to(registration_path(marked_registration.reference)) }
    end

    context "when the registration is not active" do
      let(:registration) { create(:registration, :with_ceased_exemptions) }

      before { get new_registration_permit_application_path(registration.reference) }

      it { expect(response).to redirect_to(registration_path(registration.reference)) }
    end

    %i[admin_team_user customer_service_adviser data_viewer admin_team_lead policy_adviser finance_user].each do |role|
      context "when the user is a #{role}" do
        let(:user) { create(:user, role) }

        before { get new_registration_permit_application_path(registration.reference) }

        it_behaves_like "not permitted"
      end
    end
  end

  describe "POST /registrations/:reference/permit-application" do
    context "with valid params" do
      it "marks the registration and redirects with a message" do
        post registration_permit_application_path(registration.reference), params: valid_params

        registration.reload
        expect(registration.permit_application_number).to eq("EPR/XY9876ZZ/A001")
        expect(registration.permit_application_status).to eq("duly_made")
        expect(registration.reason_for_change).to eq("Marked as permit application in progress")
        expect(response).to redirect_to(registration_path(registration.reference))

        follow_redirect!
        expect(response.body).to include("You have marked this registration as permit application in progress")
        expect(response.body).to include("Permit application in progress")
      end
    end

    context "with invalid params" do
      it "re-renders the form with errors and does not mark the registration" do
        post registration_permit_application_path(registration.reference),
             params: { permit_application_form: { permit_application_number: "", permit_application_status: "" } }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Enter the permit application number")
        expect(response.body).to include("Select a permit status")
        expect(registration.reload.permit_application_in_progress?).to be(false)
      end
    end

    context "when the user does not have permission" do
      let(:user) { create(:user, :data_viewer) }

      before { post registration_permit_application_path(registration.reference), params: valid_params }

      it_behaves_like "not permitted"
      it { expect(registration.reload.permit_application_in_progress?).to be(false) }
    end
  end

  describe "GET /registrations/:reference/permit-application/edit" do
    context "when the registration is marked" do
      before { get edit_registration_permit_application_path(marked_registration.reference) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to include("EPR/AB1234CD/A001") }
    end

    context "when the registration is not marked" do
      before { get edit_registration_permit_application_path(registration.reference) }

      it { expect(response).to redirect_to(registration_path(registration.reference)) }
    end
  end

  describe "PATCH /registrations/:reference/permit-application" do
    it "updates the permit application details" do
      patch registration_permit_application_path(marked_registration.reference), params: valid_params

      marked_registration.reload
      expect(marked_registration.permit_application_number).to eq("EPR/XY9876ZZ/A001")
      expect(marked_registration.permit_application_status).to eq("duly_made")
      expect(marked_registration.reason_for_change).to eq("Permit application details updated")
      expect(response).to redirect_to(registration_path(marked_registration.reference))
    end
  end

  describe "DELETE /registrations/:reference/permit-application" do
    it "unmarks the registration" do
      delete registration_permit_application_path(marked_registration.reference)

      marked_registration.reload
      expect(marked_registration.permit_application_number).to be_nil
      expect(marked_registration.permit_application_status).to be_nil
      expect(marked_registration.reason_for_change).to eq("Unmarked as permit application in progress")
      expect(response).to redirect_to(registration_path(marked_registration.reference))

      follow_redirect!
      expect(response.body).to include("You have unmarked this registration as permit application in progress")
    end

    context "when the user does not have permission" do
      let(:user) { create(:user, :admin_team_user) }

      before { delete registration_permit_application_path(marked_registration.reference) }

      it_behaves_like "not permitted"
      it { expect(marked_registration.reload.permit_application_in_progress?).to be(true) }
    end
  end
end
