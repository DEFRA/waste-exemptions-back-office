# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deregister Sites" do
  let(:user) { create(:user, :admin_team_lead) }

  let(:registration) { create(:registration, :multisite, site_addresses: [], registration_exemptions: []) }
  let(:site) { create(:address, :site_address, registration: registration, registration_exemptions: [registration_exemption_one, registration_exemption_two]) }

  let(:registration_exemption_one) { create(:registration_exemption, state: "active", registration:) }
  let(:registration_exemption_two) { create(:registration_exemption, state: "active", registration:) }

  let(:request_path) { deregister_registration_site_path(registration_reference: registration.reference, id: site.id) }

  before { sign_in(user) }

  describe "GET /registrations/:reference/sites/:id/deregister" do
    context "when the site can be deregistered (active)" do
      it "responds with 200 and renders the deregister exemptions template" do
        get request_path

        expect(response).to have_http_status(:ok)
        expect(response).to render_template("deregister_exemptions/new")
      end
    end

    context "when the site can not be deregistered (already deregistered)" do
      let(:status_code) { WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE }

      before do
        site.registration_exemptions.each { |re| re.update(state: "revoked") }
      end

      it "redirects to the permission page with the unsuccessful status code" do
        get request_path

        expect(response.location).to include("/pages/permission")
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end

  describe "POST /registrations/:reference/sites/:id/deregister" do
    let(:request_body) { { deregister_exemptions_form: { state_transition: "revoke", message: dereg_message } } }
    let(:status_code) { WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE }
    let(:dereg_message) { "This exemption is no longer relevant" }

    context "when the site can be deregistered by the current user" do
      it "redirects to the sites page with the successful status code" do
        post request_path, params: request_body

        expect(response.location).to include(registration_sites_path(registration_reference: registration.reference))
        expect(response.code).to eq(status_code.to_s)
      end

      it "updates the state and message for all site registration_exemptions" do
        post request_path, params: request_body

        site.registration_exemptions.each do |re|
          re.reload
          expect(re.state).to eq("revoked")
          expect(re.deregistration_message).to eq(dereg_message)
        end
      end
    end

    context "when the form submission is not valid" do
      let(:invalid_request_body) do
        { deregister_exemptions_form: { state_transition: "deactivate", message: "foo" } }
      end

      it "renders the deregister exemptions template with an ok status" do
        post request_path, params: invalid_request_body

        expect(response).to render_template("deregister_exemptions/new")
        expect(response).to have_http_status(:ok)
      end

      it "does not change the state or message for the related registration exemptions" do
        expect { post request_path, params: invalid_request_body }.not_to change(site, :site_status)

        site.registration_exemptions.each do |re|
          re.reload
          expect(re.state).to eq("active")
          expect(re.deregistration_message).to be_nil
        end
      end
    end

    context "when the site can not be deregistered (already deregistered)" do
      let(:status_code) { WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE }

      before do
        site.registration_exemptions.each { |re| re.update(state: "revoked") }
      end

      it "redirects to the permission page with the unsuccessful status code" do
        post request_path, params: request_body

        expect(response.location).to include("/pages/permission")
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end
end
