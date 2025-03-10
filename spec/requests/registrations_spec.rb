# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations" do
  let(:registration) { create(:registration) }

  describe "GET /registrations/:reference" do
    context "when a user is signed in" do
      before do
        sign_in(create(:user))
      end

      it "renders the show template and includes the correct reference" do
        get "/registrations/#{registration.reference}"

        expect(response).to render_template(:show)
        expect(response.body).to include(registration.reference)
      end

      it "includes the correct back link" do
        search_terms = { term: "foo", filter: "registrations", page: "2" }
        get "/registrations/#{registration.reference}", params: search_terms

        expect(response.body).to include("Back to search results")

        root_path_with_search_terms = root_path(search_terms).gsub("&", "&amp;")
        expect(response.body).to include(root_path_with_search_terms)
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
