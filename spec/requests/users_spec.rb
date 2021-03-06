# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "/users" do
    context "when a system is signed in" do
      let(:user) { create(:user, :system) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template, returns a 200 response, includes the correct content and displays a list of users" do
        listed_user = create(:user, email: "aaaaaaaaaaa@example.com")

        get "/users"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
        expect(response.body).to include("Manage back office users")
        expect(response.body).to include(listed_user.email)
      end
    end

    context "when a non-system user is signed in" do
      let(:user) { create(:user, :data_agent) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/users"

        expect(response).to redirect_to("/pages/permission")
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        get "/users"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
