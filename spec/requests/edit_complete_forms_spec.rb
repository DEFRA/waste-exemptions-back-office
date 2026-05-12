# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Edit Complete Forms" do
  let(:form) { build(:edit_complete_form) }
  let(:edit_enabled) { "true" }
  let(:user) { create(:user, :admin_team_user) }

  before do
    sign_in(user)
    WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
  end

  after do
    WasteExemptionsEngine.configuration.edit_enabled = "true"
  end

  describe "GET edit_complete_form" do
    let(:request_path) { "/#{form.token}/edit-complete" }

    it "renders the expected template" do
      get request_path
      expect(response).to render_template("edit_complete_forms/new")
    end

    it "returns a 200 status code" do
      get request_path
      expect(response).to have_http_status(:ok)
    end

    it "completes the edit registration" do
      registration = form.transient_registration.registration

      expect { get request_path }
        .to change { registration.reload.operator_name }.to(form.transient_registration.operator_name)
        .and change {
          EditRegistration.where(reference: registration.reference).count
        }.from(1).to(0)
    end

    it "assigns the current user as whodunnit", :versioning do
      registration = form.transient_registration.registration

      get request_path

      expect(registration.reload.versions.last.whodunnit).to eq(user.id.to_s)
    end

    context "when the token is not a valid registration reference" do
      let(:request_path) { "/WEX987654/edit-complete" }

      it "raises a page not found error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "unable to go submit GET back" do
    let(:request_path) { "/#{form.token}/edit-complete/back" }

    it "raises an error" do
      expect { get request_path }.to raise_error(ActionController::RoutingError)
    end
  end

  describe "POST edit_complete_form" do
    let(:request_path) { "/#{form.token}/edit-complete" }

    it "raises an error" do
      expect { post request_path }.to raise_error(ActionController::RoutingError)
    end
  end
end
