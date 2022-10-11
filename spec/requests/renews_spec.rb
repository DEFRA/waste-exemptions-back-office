# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

RSpec.describe "Renews", type: :request do
  let(:registration) { create(:registration) }
  let(:transient_registration_token) { WasteExemptionsEngine::RenewingRegistration.last.token }

  describe "GET /renews/:reference" do
    let(:request_path) { "/renew/#{registration.reference}" }

    before do
      sign_in(user) if defined?(user)
    end

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_agent) }

      it "redirects to permission page" do
        get request_path
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when an admin agent user is signed in" do
      let(:user) { create(:user, :admin_agent) }

      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:load_company).and_return(true)
        allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:company_name).and_return(Faker::Company.name)
        allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:registered_office_address_lines).and_return(["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"])
      end
      # rubocop:enable RSpec/AnyInstance

      it "return a 303 redirect code and redirect to the renewal start form" do
        get request_path

        path = WasteExemptionsEngine::Engine.routes.url_helpers.check_registered_name_and_address_forms_path(token: transient_registration_token)
        expect(response).to redirect_to(path)
        expect(response.code).to eq("303")
      end

      context "when the renewal was already started" do
        let(:renewing_registration) { create(:renewing_registration, workflow_state: "contact_name_form") }
        let(:request_path) { "/renew/#{renewing_registration.reference}" }

        it "redirects to the correct template status" do
          get request_path

          path = WasteExemptionsEngine::Engine.routes.url_helpers.check_registered_name_and_address_forms_path(token: transient_registration_token)
          expect(response).to redirect_to(path)
        end
      end

      context "when the business type is a company or llp" do
        it "redirects to the check registered name and address form, creates a new RenewingRegistration and returns a 303 status code" do
          get request_path

          path = WasteExemptionsEngine::Engine.routes.url_helpers.check_registered_name_and_address_forms_path(token: transient_registration_token)
          expect(response).to redirect_to(path)
          expect(response.code).to eq("303")
        end
      end

      context "when the business type is not a company or llp" do
        before { registration.update(business_type: "soleTrader") }

        it "redirects to the renewal start form, creates a new RenewingRegistration and returns a 303 status code" do
          get request_path

          path = WasteExemptionsEngine::Engine.routes.url_helpers.new_renewal_start_form_path(token: transient_registration_token)
          expect(response).to redirect_to(path)
          expect(response.code).to eq("303")
        end
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get request_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
