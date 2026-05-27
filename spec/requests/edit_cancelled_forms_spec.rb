# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Edit Cancelled Forms" do
  let(:form) { build(:edit_cancelled_form) }
  let(:edit_enabled) { "true" }

  before do
    sign_in(create(:user, :admin_team_user))
    WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
  end

  after do
    WasteExemptionsEngine.configuration.edit_enabled = "true"
  end

  describe "GET edit_cancelled_form" do
    let(:request_path) { "/#{form.token}/edit-cancelled" }

    it "renders the expected template" do
      get request_path
      expect(response).to render_template("edit_cancelled_forms/new")
    end

    it "returns a 200 status code" do
      get request_path
      expect(response).to have_http_status(:ok)
    end

    it "cancels the edit registration" do
      expect { get request_path }
        .to change { WasteExemptionsEngine::BackOfficeEditRegistration.where(reference: form.transient_registration.reference).count }.from(1).to(0)
    end

    context "when `WasteExemptionsEngine.configuration.edit_enabled` is anything other than \"true\"" do
      let(:edit_enabled) { "false" }

      it "raises a page not found error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "unable to go submit GET back" do
    let(:request_path) { "/#{form.token}/edit-cancelled/back" }

    it "raises an error" do
      expect { get request_path }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "POST edit_cancelled_form" do
    let(:request_path) { "/#{form.token}/edit-cancelled" }

    it "raises an error" do
      expect { post request_path }.to raise_error(ActionController::RoutingError)
    end
  end
end
