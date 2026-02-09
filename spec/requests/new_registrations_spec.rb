# frozen_string_literal: true

require "rails_helper"

RSpec.describe "NewRegistrations" do
  let(:new_registration) { create(:new_charged_registration) }

  describe "GET /new-registrations/:id" do
    context "when a user is signed in" do
      before do
        sign_in(create(:user))
      end

      it "renders the show template" do
        get "/new-registrations/#{new_registration.id}"

        expect(response).to render_template(:show)
      end

      it "includes the correct back link" do
        search_terms = { term: "foo", filter: "new_registrations", page: "2" }
        get "/new-registrations/#{new_registration.id}", params: search_terms

        expect(response.body).to include("Back to search results")

        root_path_with_search_terms = root_path(search_terms).gsub("&", "&amp;")
        expect(response.body).to include(root_path_with_search_terms)
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/new-registrations/#{new_registration.id}"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
