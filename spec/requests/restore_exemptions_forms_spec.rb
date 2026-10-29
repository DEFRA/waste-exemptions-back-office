# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Restore Exemptions Forms" do
  let(:user) { create(:user, :admin_team_lead) }
  let(:request_body) do
    { restore_exemptions_form: { message: "This registration was deregistered in error" } }
  end
  let(:successful_redirection_code) { WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE }
  let(:unsuccessful_redirection_code) { WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE }

  def active_registration
    registration = create(:registration)
    registration.registration_exemptions.each do |re|
      re.state = "active"
      re.save!
    end
    registration
  end

  before do
    sign_in(user)
  end

  describe "Registration Restoration" do
    let(:revoked_registration) do
      registration = active_registration
      registration.registration_exemptions.each do |re|
        re.revoke!
        re.save!
      end
      registration
    end
    # A registration where one exemption was ceased before the rest were revoked.
    let(:partially_deregistered_registration) do
      registration = active_registration
      registration.registration_exemptions.first.update!(state: "ceased", deregistered_at: 1.month.ago)
      registration.registration_exemptions.drop(1).each(&:revoke!)
      registration
    end
    let(:good_request_path) { "/registrations/restore/#{revoked_registration.id}" }
    let(:bad_request_path) { "/registrations/restore/#{active_registration.id}" }
    let(:blocked_request_path) { "/registrations/restore/#{partially_deregistered_registration.id}" }

    describe "GET /registrations/restore/:id" do
      context "when the registration can be restored by the current_user" do
        it "responds to the GET request with a 200 status code and renders the appropriate template" do
          get good_request_path

          expect(response).to have_http_status(:ok)
          expect(response).to render_template("restore_exemptions/new")
          expect(response.body).to include(
            I18n.t("restore_exemptions.new.registration_heading",
                   registration_reference: revoked_registration.reference)
          )
        end
      end

      context "when the registration has exemptions deregistered before it was deregistered" do
        it "renders the blocked template" do
          get blocked_request_path

          expect(response).to have_http_status(:ok)
          expect(response).to render_template("restore_exemptions/blocked")
          expect(response.body).to include(I18n.t("restore_exemptions.blocked.previously_deregistered"))
          expect(response.body).to include(I18n.t("restore_exemptions.blocked.restore_exemptions_first"))
        end
      end

      context "when the registration can not be restored by the current_user" do
        it "redirects to the permission page" do
          get bad_request_path

          expect(response.location).to include("/pages/permission")
          expect(response.code).to eq(unsuccessful_redirection_code.to_s)
        end
      end
    end

    describe "POST /registrations/restore/:id" do
      context "when the registration can be restored by the current_user" do
        let(:invalid_request_body) { { restore_exemptions_form: { message: "" } } }

        it "updates the registration state and redirects to the registration" do
          registration = revoked_registration
          expect(registration.state).to eq("revoked")

          post good_request_path, params: request_body

          expect(response.location).to include("registrations/#{registration.reference}")
          expect(response.code).to eq(successful_redirection_code.to_s)
          expect(WasteExemptionsEngine::Registration.find(registration.id).state).to eq("active")
        end

        it "re-renders the form when the message is missing" do
          post good_request_path, params: invalid_request_body

          expect(response).to render_template("restore_exemptions/new")
          expect(response).to have_http_status(:ok)
        end
      end

      context "when the registration has exemptions deregistered before it was deregistered" do
        it "renders the blocked template and leaves the registration deregistered" do
          registration = partially_deregistered_registration

          post blocked_request_path, params: request_body

          expect(response).to render_template("restore_exemptions/blocked")
          expect(WasteExemptionsEngine::Registration.find(registration.id).state).to eq("revoked")
        end
      end

      context "when the registration can not be restored by the current_user" do
        it "redirects to the permission page" do
          post bad_request_path, params: request_body

          expect(response.location).to include("/pages/permission")
          expect(response.code).to eq(unsuccessful_redirection_code.to_s)
        end
      end
    end
  end

  describe "Registration Exemption Restoration" do
    let(:revoked_registration_exemption) do
      reg_exemption = active_registration.registration_exemptions.first
      reg_exemption.revoke!
      reg_exemption
    end
    let(:active_registration_exemption) { active_registration.registration_exemptions.first }
    let(:good_request_path) { "/registration-exemptions/restore/#{revoked_registration_exemption.id}" }
    let(:bad_request_path) { "/registration-exemptions/restore/#{active_registration_exemption.id}" }

    describe "GET /registration-exemptions/restore/:id" do
      context "when the registration_exemption can be restored by the current_user" do
        it "renders the appropriate template and responds to the GET request with a 200 status code" do
          get good_request_path

          expect(response).to render_template("restore_exemptions/new")
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(I18n.t("restore_exemptions.new.exemption_heading"))
          expect(response.body).to include(revoked_registration_exemption.exemption.code)
        end
      end

      context "when the registration_exemption can not be restored by the current_user" do
        it "redirects to the permission page" do
          get bad_request_path

          expect(response.location).to include("/pages/permission")
          expect(response.code).to eq(unsuccessful_redirection_code.to_s)
        end
      end
    end

    describe "POST /registration-exemptions/restore/:id" do
      context "when the registration_exemption can be restored by the current_user" do
        it "updates the registration_exemption state and redirects to the registration" do
          reg_exemption = revoked_registration_exemption

          post good_request_path, params: request_body

          expect(response.location).to include("registrations/#{reg_exemption.registration.reference}")
          expect(response.code).to eq(successful_redirection_code.to_s)

          after_post_record = WasteExemptionsEngine::RegistrationExemption.find(reg_exemption.id)
          expect(after_post_record.state).to eq("active")
          expect(after_post_record.deregistered_at).to be_nil
          expect(after_post_record.reason_for_change).to eq(request_body[:restore_exemptions_form][:message])
        end
      end

      context "when the registration_exemption can not be restored by the current_user" do
        it "redirects to the permission page" do
          post bad_request_path, params: request_body

          expect(response.location).to include("/pages/permission")
          expect(response.code).to eq(unsuccessful_redirection_code.to_s)
        end
      end
    end
  end
end
