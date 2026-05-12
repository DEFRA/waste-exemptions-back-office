# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Edit Forms" do
  let(:form) { build(:edit_form) }
  let(:registration) { create(:registration) }
  let(:user) { create(:user, :admin_team_user) }
  let(:edit_enabled) { "true" }

  before do
    sign_in(user)
    WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
  end

  after do
    WasteExemptionsEngine.configuration.edit_enabled = "true"
  end

  describe "GET edit_form" do
    let(:request_path) { "/#{form.token}/edit" }

    context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
      it "renders the appropriate template and returns a 200 status code" do
        get request_path

        aggregate_failures do
          expect(response).to render_template("edit_forms/new")
          expect(response).to have_http_status(:ok)
        end
      end

      context "when the token is a registration reference" do
        let(:request_path) { "/#{registration.reference}/edit" }

        it "renders the appropriate template, returns a 200 status code and loads the correct page" do
          get request_path

          aggregate_failures do
            expect(response).to render_template("edit_forms/new")
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(registration.reference)
          end
        end

        it "creates a new EditRegistration for the registration when an edit is not already in progress" do
          expect { get request_path }.to change {
            EditRegistration.where(reference: registration.reference).count
          }.from(0).to(1)
        end
      end

      context "when the registration already has an edit in progress" do
        let(:edit_registration) { create(:edit_registration) }
        let(:request_path) { "/#{edit_registration.reference}/edit/" }

        it "does not create a new EditRegistration for the registration" do
          expect { get request_path }.not_to change {
            EditRegistration.where(reference: edit_registration.reference).count
          }.from(1)
        end
      end

      context "when the token is not a registration reference" do
        let(:request_path) { "/WEX987654/edit" }

        it "raises a page not found error" do
          expect { get request_path }.to raise_error(ActionController::RoutingError)
        end
      end
    end

    context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"false\"" do
      let(:edit_enabled) { "false" }

      it "raises a page not found error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "unable to go submit GET back" do
    let(:request_path) { "/#{form.token}/edit/back" }

    it "raises an error" do
      expect { get request_path }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "POST edit_form" do
    let(:request_path) { "/#{form.token}/edit/" }

    context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
      let(:status_code) { WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE }

      it "responds to the POST request with a successful redirection status code" do
        post request_path
        expect(response.code).to eq(status_code.to_s)
      end
    end

    context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"false\"" do
      let(:edit_enabled) { "false" }

      it "raises a page not found error" do
        expect { post request_path }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  %w[
    main_people
    registration_number
    operator_name
    operator_postcode
    contact_name
    contact_position
    contact_phone
    contact_email
    contact_postcode
    on_a_farm
    is_a_farmer
    operation_sites
  ].each do |edit_action|
    describe "GET edit_#{edit_action}" do
      let(:request_path) { "/#{form.token}/edit/#{edit_action}" }
      let(:next_workflow_state) { "#{edit_action}_form" }
      let(:redirection_path) { new_form_path_for(next_workflow_state, form.token) }
      let(:status_code) { WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE }

      it "redirects to the appropriate location" do
        get request_path
        expect(response.location).to include(redirection_path)
      end

      it "responds to the GET request with a successful redirection status code" do
        get request_path
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end

  describe "GET edit_site_grid_reference" do
    let(:edit_registration) { create(:edit_registration, workflow_state: "operation_sites_form") }
    let(:request_path) { "/#{edit_registration.token}/edit/site_grid_reference" }
    let(:redirection_path) do
      WasteExemptionsEngine::Engine.routes.url_helpers.new_site_grid_reference_form_path(
        token: edit_registration.token
      )
    end

    it "redirects to the appropriate location" do
      get request_path
      expect(response.location).to include(redirection_path)
    end
  end

  describe "GET cancel" do
    let(:request_path) { "/#{form.token}/edit/cancel" }

    it "redirects to the edit cancellation confirmation" do
      get request_path
      expect(response.location).to include("/#{form.token}/confirm-edit-cancelled")
    end
  end

  def new_form_path_for(workflow_state, token)
    return "/#{token}/operation_sites" if workflow_state == "operation_sites_form"

    WasteExemptionsEngine::Engine.routes.url_helpers.public_send(
      :"new_#{workflow_state}_path",
      token: token
    )
  end
end
