# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations" do
  let(:registration) { create(:registration) }

  describe "GET /registrations/:reference" do
    context "when a user is signed in" do
      before { sign_in(create(:user)) }

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

  describe "PATCH /registrations/:reference/mark_as_legacy_bulk" do
    let(:resource) { create(:registration) }

    context "when a valid user is not signed in" do
      before do
        sign_out(create(:user))
        patch "/registrations/#{resource.reference}/mark_as_legacy_bulk"
      end

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when a qualified user is signed in" do
      before { sign_in(create(:user, role: :developer)) }

      it "updates the is_legacy_bulk attribute" do
        expect { patch "/registrations/#{resource.reference}/mark_as_legacy_bulk" }
          .to change { resource.reload.is_legacy_bulk }.to true
      end

      it "returns to the registration details page" do
        patch "/registrations/#{resource.reference}/mark_as_legacy_bulk"

        expect(response).to redirect_to "/registrations/#{resource.reference}"
      end

      it "shows a flash message" do
        patch "/registrations/#{resource.reference}/mark_as_legacy_bulk"
        follow_redirect!

        expect(response.body).to include I18n.t("registrations.marked_as_legacy_bulk")
      end
    end
  end

  describe "PATCH /registrations/:reference/mark_as_legacy_linear" do
    let(:resource) { create(:registration) }

    context "when a valid user is not signed in" do
      before do
        sign_out(create(:user))
        patch "/registrations/#{resource.reference}/mark_as_legacy_linear"
      end

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when a qualified user is signed in" do
      before { sign_in(create(:user, role: :developer)) }

      it "updates the is_linear attribute" do
        expect { patch "/registrations/#{resource.reference}/mark_as_legacy_linear" }
          .to change { resource.reload.is_linear }.to true
      end

      it "returns to the registration details page" do
        patch "/registrations/#{resource.reference}/mark_as_legacy_linear"

        expect(response).to redirect_to "/registrations/#{resource.reference}"
      end

      it "shows a flash message" do
        patch "/registrations/#{resource.reference}/mark_as_legacy_linear"
        follow_redirect!

        expect(response.body).to include I18n.t("registrations.marked_as_legacy_linear")
      end
    end
  end
end
