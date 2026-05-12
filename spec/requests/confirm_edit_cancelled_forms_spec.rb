# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Confirm Edit Cancelled Forms" do
  let(:form) { build(:confirm_edit_cancelled_form) }
  let(:request_path) { "/#{form.token}/confirm-edit-cancelled" }

  before do
    sign_in(create(:user, :admin_team_user))
    WasteExemptionsEngine.configuration.edit_enabled = "true"
  end

  describe "GET confirm_edit_cancelled_form" do
    it "renders the expected template" do
      get request_path
      expect(response).to render_template("confirm_edit_cancelled_forms/new")
    end

    it "returns a 200 status code" do
      get request_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST confirm_edit_cancelled_form" do
    it "moves to the cancelled page" do
      expect do
        post request_path, params: { confirm_edit_cancelled_form: {} }
      end.to change { form.transient_registration.reload.workflow_state }.to("edit_cancelled_form")
    end

    it "redirects to the next form" do
      post request_path, params: { confirm_edit_cancelled_form: {} }
      expect(response).to have_http_status(:see_other)
    end
  end
end
