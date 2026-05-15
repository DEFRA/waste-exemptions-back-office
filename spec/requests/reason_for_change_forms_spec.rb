# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ReasonForChange Form" do
  let(:form) { build(:reason_for_change_form) }
  let(:edit_enabled) { "true" }

  before do
    sign_in(create(:user, :admin_team_user))
    WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
  end

  after do
    WasteExemptionsEngine.configuration.edit_enabled = "true"
  end

  describe "GET reason_for_change_form" do
    let(:request_path) { "/#{form.token}/reason-for-change" }

    it "renders the expected template" do
      get request_path
      expect(response).to render_template("reason_for_change_forms/new")
    end

    it "returns a 200 status code" do
      get request_path
      expect(response).to have_http_status(:ok)
    end

    context "when `WasteExemptionsEngine.configuration.edit_enabled` is anything other than \"true\"" do
      let(:edit_enabled) { "false" }

      it "raises a page not found error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "unable to go submit GET back" do
    let(:request_path) { "/#{form.token}/reason-for-change/back" }

    it "raises an error" do
      expect { get request_path }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "POST reason_for_change_form" do
    let(:request_path) { "/#{form.token}/reason-for-change" }
    let(:request_body) do
      { reason_for_change_form: { reason_for_change: "Correcting registration details" } }
    end

    it "updates the reason for change" do
      expect do
        post request_path, params: request_body
      end.to change { form.transient_registration.reload.reason_for_change }.to("Correcting registration details")
    end

    it "moves to the declaration page" do
      post request_path, params: request_body
      expect(form.transient_registration.reload.workflow_state).to eq("declaration_form")
    end

    it "responds to the POST request with correct status code" do
      post request_path, params: request_body
      expect(response.code).to eq(WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE.to_s)
    end

    context "when `WasteExemptionsEngine.configuration.edit_enabled` is anything other than \"true\"" do
      let(:edit_enabled) { "false" }

      it "raises a page not found error" do
        expect { post request_path, params: request_body }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
