# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Back office edit forms" do
    let(:registration) { create(:registration) }
    let(:user) { create(:user, :admin_team_user) }

    before { sign_in(user) }

    describe "GET /:reference/edit" do
      it "creates a back-office edit registration and renders the edit summary" do
        expect do
          get "/#{registration.reference}/edit"
        end.to change { BackOfficeEditRegistration.where(reference: registration.reference).count }.from(0).to(1)

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/back_office_edit_forms/new")
        end
      end
    end
  end
end
