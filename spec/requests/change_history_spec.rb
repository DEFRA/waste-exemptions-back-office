# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Change History" do
  let(:registration) { create(:registration) }
  let(:user) { create(:user, role: :customer_service_adviser) }

  before do
    sign_in(user)
  end

  describe "GET /bo/registrations/:reference/change_history/", :versioning do
    context "when change history is present" do
      before do
        registration.update(contact_first_name: "Johnny", contact_last_name: "Smith", contact_position: "Manager")
      end

      it "renders the index template, returns a 200 response and includes the correct content" do
        get "/registrations/#{registration.reference}/change_history"

        aggregate_failures do
          expect(response).to render_template(:index)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Change history")
          expect(response.body).to include("Johnny")
          expect(response.body).to include("Smith")
          expect(response.body).to include("Manager")
        end
      end
    end

    context "when no changes made to registration apart from initial creation" do
      it "renders the index template, returns a 200 response and includes the correct content" do
        get "/registrations/#{registration.reference}/change_history"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Change history")
        expect(response.body).to include("System")
      end
    end

    context "when user has no access or registration does not exist" do
      it "redirects to the permissions page" do
        get "/registrations/NOT-EXISTING/change_history"

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
