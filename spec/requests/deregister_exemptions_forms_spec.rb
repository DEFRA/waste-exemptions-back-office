# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deregister Exemptions Forms" do
  let(:form) { DeregisterExemptionsForm.new }
  let(:user) { create(:user, :super_agent) }

  before do
    sign_in(user)
  end

  describe "Registration Deregistration" do
    let(:active_registration) do
      registration = create(:registration)
      registration.registration_exemptions.each do |re|
        re.state = "active"
        re.save!
      end
      registration
    end
    let(:inactive_registration) do
      registration = create(:registration)
      registration.registration_exemptions.each(&:cease!)
      registration
    end
    let(:good_request_path) { "/registrations/deregister/#{active_registration.id}" }
    let(:bad_request_path) { "/registrations/deregister/#{inactive_registration.id}" }

    describe "GET /registrations/deregister/:id" do
      context "when the registration can be de-registered by the current_user" do
        it "responds to the GET request with a 200 status code and renders the appropriate template" do
          get good_request_path

          expect(response).to have_http_status(:ok)
          expect(response).to render_template("deregister_exemptions/new")
        end
      end

      context "when the registration can not be de-registered by the current_user" do
        status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

        it "responds to the GET request with a #{status_code} status code and renders the appropriate template" do
          get bad_request_path

          expect(response.location).to include("/pages/permission")
          expect(response.code).to eq(status_code.to_s)
        end
      end
    end

    describe "POST /registrations/deregister/:id" do
      let(:request_body) do
        { deregister_exemptions_form: { state_transition: "revoke", message: "This exemption is no longer relevant" } }
      end

      context "when the registration can be de-registered by the current_user" do
        context "when the form is valid" do
          status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

          it "renders the registration template, responds to the POST request with a #{status_code} status code and updates the registration state" do
            reg_id = active_registration.id
            before_post_record = WasteExemptionsEngine::Registration.find(reg_id)
            expect(before_post_record.state).to eq("active")

            post good_request_path, params: request_body

            expect(response.location).to include("registrations/#{active_registration.reference}")
            expect(response.code).to eq(status_code.to_s)
            form_data = request_body[:deregister_exemptions_form]
            after_post_record = WasteExemptionsEngine::Registration.find(reg_id)
            expect(after_post_record.state).to eq("#{form_data[:state_transition]}d")
          end
        end

        context "when the form is not valid" do
          let(:invalid_request_body) do
            { deregister_exemptions_form: { state_transition: "deactivate", message: "foo" } }
          end

          it "renders the same template and responds to the POST request with a 200 status code" do
            post good_request_path, params: invalid_request_body

            expect(response).to render_template("deregister_exemptions/new")
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context "when the registration can not be de-registered by the current_user" do
        status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

        it "renders the appropriate template and responds to the POST request with a #{status_code} status code" do
          post bad_request_path, params: request_body

          expect(response.location).to include("/pages/permission")
          expect(response.code).to eq(status_code.to_s)
        end
      end
    end
  end

  describe "Registration Exemption Deregistration" do
    let(:active_registration_exemption) do
      reg_exemption = create(:registration).registration_exemptions.first
      reg_exemption.state = "active"
      reg_exemption.save!
      reg_exemption
    end
    let(:inactive_registration_exemption) do
      reg_exemption = create(:registration).registration_exemptions.first
      reg_exemption.state = "revoked"
      reg_exemption.save!
      reg_exemption
    end
    let(:good_request_path) { "/registration-exemptions/deregister/#{active_registration_exemption.id}" }
    let(:bad_request_path) { "/registration-exemptions/deregister/#{inactive_registration_exemption.id}" }

    describe "GET /registration_exemptions/deregister/:id" do
      context "when the registration_exemption can be de-registered by the current_user" do
        it "renders the appropriate template and responds to the GET request with a 200 status code" do
          get good_request_path

          expect(response).to render_template("deregister_exemptions/new")
          expect(response).to have_http_status(:ok)
        end
      end

      context "when the registration_exemption can not be de-registered by the current_user" do
        status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

        it "renders the appropriate template and responds to the GET request with a #{status_code} status code" do
          get bad_request_path

          expect(response.location).to include("/pages/permission")
          expect(response.code).to eq(status_code.to_s)
        end
      end
    end

    describe "POST /registration_exemptions/deregister/:id" do
      let(:request_body) do
        { deregister_exemptions_form: { state_transition: "revoke", message: "This exemption is no longer relevant" } }
      end

      context "when the registration_exemption can be de-registered by the current_user" do
        context "when the form is valid" do
          status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

          it "renders the registration template, responds to the POST request with a #{status_code} status code and updates the registration_exemption state" do
            reg_exemp_id = active_registration_exemption.id
            before_post_record = WasteExemptionsEngine::RegistrationExemption.find(reg_exemp_id)
            expect(before_post_record.state).to eq("active")
            expect(before_post_record.deregistration_message).to be_blank

            post good_request_path, params: request_body

            expect(response.location).to include("registrations/#{active_registration_exemption.registration.reference}")
            expect(response.code).to eq(status_code.to_s)
            form_data = request_body[:deregister_exemptions_form]
            after_post_record = WasteExemptionsEngine::RegistrationExemption.find(reg_exemp_id)
            expect(after_post_record.state).to eq("#{form_data[:state_transition]}d")
            expect(after_post_record.deregistration_message).to eq(form_data[:message])
          end
        end

        context "when the form is not valid" do
          let(:invalid_request_body) do
            { deregister_exemptions_form: { state_transition: "deactivate", message: "foo" } }
          end

          it "renders the same template and responds to the POST request with a 200 status code" do
            post good_request_path, params: invalid_request_body

            expect(response).to render_template("deregister_exemptions/new")
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context "when the registration_exemption can not be de-registered by the current_user" do
        status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

        it "renders the appropriate template and responds to the POST request with a #{status_code} status code" do
          post bad_request_path, params: request_body

          expect(response.location).to include("/pages/permission")
          expect(response.code).to eq(status_code.to_s)
        end
      end
    end
  end
end
