# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deregistrations" do
  let(:registration) { create(:registration) }

  describe "GET #show" do
    context "when a user is signed in" do
      before do
        sign_in(create(:user))
      end

      it "renders the show template and includes the correct reference" do
        get "/deregistrations/#{registration.reference}"

        expect(response).to render_template(:show)
        expect(response.body).to include(registration.reference)
      end

      it "includes the correct back link" do
        get "/deregistrations/#{registration.reference}"

        expect(response.body).to include("Back to main details")
        expect(response.body).to include(registration_path(registration.reference))
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/registrations/#{registration.id}"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
