# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  describe "/users" do
    context "when a system user is signed in" do
      let(:user) { create(:user, :system) }

      before { sign_in(user) }

      it "renders the index template, returns a 200 response and includes the correct content" do
        active_user = create(:user, email: "aaaaaaaaaaa@example.com")
        deactivated_user = create(:user, email: "aaaaaaaaaaa2@example.com", active: false)

        get "/users"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Manage back office users")
        expect(response.body).to include("Show all users")
        expect(response.body).to include(active_user.email)
        expect(response.body).not_to include(deactivated_user.email)
      end
    end

    context "when a non-system user is signed in" do
      let(:user) { create(:user, :data_agent) }

      before { sign_in(user) }

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

  describe "/users/all" do
    context "when a system user is signed in" do
      let(:user) { create(:user, :system) }

      before { sign_in(user) }

      context "with the default request format" do
        let!(:active_user) { create(:user, email: "aaaaaaaaaaa@example.com") }
        let!(:deactivated_user) { create(:user, email: "aaaaaaaaaaa2@example.com", active: false) }

        before { get "/users/all" }

        it { expect(response).to render_template(:index) }
        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("Show enabled users only") }
        it { expect(response.body).to include(active_user.email) }
        it { expect(response.body).to include(deactivated_user.email) }
      end

      context "with csv request format" do
        let(:expected_content) { Faker::Lorem.sentence }
        let(:user_role_export_service) { instance_double(Reports::UserRoleExportService) }

        before do
          allow(Reports::UserRoleExportService).to receive(:new).and_return(user_role_export_service)
          allow(user_role_export_service).to receive(:run).and_return(expected_content)

          get "/users/all.csv"
        end

        it { expect(response.body).to eq expected_content }
      end
    end

    context "when a non-system user is signed in" do
      let(:user) { create(:user, :data_agent) }

      before { sign_in(user) }

      it "redirects to the permissions error page" do
        get "/users/all"

        expect(response).to redirect_to("/pages/permission")
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        get "/users/all"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
