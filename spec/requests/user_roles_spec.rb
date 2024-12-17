# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Roles" do
  let(:role_change_user) { create(:user, :data_viewer) }
  let(:admin_team_user_user) { create(:user, :admin_team_user) }

  describe "GET /users/role/:id" do
    context "when a admin_team_user user is signed in" do
      before do
        sign_in(admin_team_user_user)
      end

      it "renders the edit template" do
        get "/users/role/#{role_change_user.id}"

        expect(response).to render_template(:edit)
      end
    end

    context "when a non-admin_team_user user is signed in" do
      let(:user) { create(:user, :data_viewer) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/users/role/#{role_change_user.id}"

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "POST /users/role" do
    let(:params) { { role: "customer_service_adviser" } }

    context "when a admin_team_user user is signed in" do
      before do
        sign_in(admin_team_user_user)
      end

      it "updates the user role, redirects to the user list and assigns the correct whodunnit to the version", :versioning do
        post "/users/role/#{role_change_user.id}", params: { user: params }

        expect(role_change_user.reload.role).to eq(params[:role])
        expect(response).to redirect_to(users_path)
        expect(role_change_user.reload.versions.last.whodunnit).to eq(admin_team_user_user.id.to_s)
      end

      context "when the params are invalid" do
        let(:params) { { role: "foo" } }

        it "does not update the user role and renders the edit template" do
          post "/users/role/#{role_change_user.id}", params: { user: params }

          expect(role_change_user.reload.role).to eq("data_viewer")
          expect(response).to render_template(:edit)
        end
      end

      context "when the params are blank" do
        it "does not update the user role and renders the edit template" do
          post "/users/role/#{role_change_user.id}"

          expect(role_change_user.reload.role).to eq("data_viewer")
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when a non-admin_team_user user is signed in" do
      let(:user) { create(:user, :data_viewer) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/users/role/#{role_change_user.id}", params: { user: params }

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
