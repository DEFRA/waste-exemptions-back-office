# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Resend User Invites" do
  let(:invited_user) { create(:user, :invited) }
  let(:accepted_user) { create(:user) }

  describe "GET /users/resend-invite/:id" do
    context "when a admin_team_user user is signed in" do
      let(:user) { create(:user, :admin_team_user) }

      before do
        sign_in(user)
      end

      context "when the user has a pending invitation" do
        it "renders the new template" do
          get "/users/resend-invite/#{invited_user.id}"

          expect(response).to render_template(:new)
        end
      end

      context "when the user has already accepted their invitation" do
        it "redirects to the user list" do
          get "/users/resend-invite/#{accepted_user.id}"

          expect(response).to redirect_to(users_path)
        end
      end

      context "when the invited user is deactivated" do
        let(:invited_user) { create(:user, :invited, :inactive) }

        it "redirects to the user list" do
          get "/users/resend-invite/#{invited_user.id}"

          expect(response).to redirect_to(users_path)
        end
      end

      context "when the current user cannot administer the invited user's role" do
        let(:invited_user) { create(:user, :invited, :service_manager) }

        it "redirects to the user list" do
          get "/users/resend-invite/#{invited_user.id}"

          expect(response).to redirect_to(users_path)
        end
      end
    end

    context "when a non-admin_team_user user is signed in" do
      let(:user) { create(:user, :data_viewer) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/users/resend-invite/#{invited_user.id}"

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "POST /users/resend-invite/:id" do
    context "when a admin_team_user user is signed in" do
      let(:user) { create(:user, :admin_team_user) }

      before do
        sign_in(user)
      end

      context "when the user has a pending invitation" do
        it "resends the invitation email, resets the invitation expiry and redirects to the user list" do
          old_token = invited_user.invitation_token
          old_created_at = invited_user.invitation_created_at

          expect { post "/users/resend-invite/#{invited_user.id}" }
            .to change { ActionMailer::Base.deliveries.count }.by(1)

          expect(response).to redirect_to(users_path)

          invited_user.reload
          expect(invited_user.invitation_token).not_to eq(old_token)
          expect(invited_user.invitation_created_at).to be > old_created_at
          expect(invited_user.invitation_created_at).to be_within(1.minute).of(Time.zone.now)
          expect(ActionMailer::Base.deliveries.last.to).to eq([invited_user.email])
        end
      end

      context "when the user has already accepted their invitation" do
        it "does not send an email and redirects to the user list" do
          expect { post "/users/resend-invite/#{accepted_user.id}" }
            .not_to change { ActionMailer::Base.deliveries.count }

          expect(response).to redirect_to(users_path)
        end
      end

      context "when the invited user is deactivated" do
        let(:invited_user) { create(:user, :invited, :inactive) }

        it "does not send an email and redirects to the user list" do
          expect { post "/users/resend-invite/#{invited_user.id}" }
            .not_to change { ActionMailer::Base.deliveries.count }

          expect(response).to redirect_to(users_path)
        end
      end
    end

    context "when a non-admin_team_user user is signed in" do
      let(:user) { create(:user, :data_viewer) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/users/resend-invite/#{invited_user.id}"

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
