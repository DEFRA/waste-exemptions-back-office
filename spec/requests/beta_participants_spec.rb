# frozen_string_literal: true

require "rails_helper"

RSpec.describe "BetaParticipants" do
  describe "/beta_participants" do
    context "when a user is signed in" do
      let(:user) { create(:user, :admin_team_user) }
      let(:original_registration) { create(:registration) }

      before { sign_in(user) }

      it "renders the index template, returns a 200 response and includes the correct content" do
        get "/beta_participants"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Manage private beta users")
      end

      context "when there are no beta participants" do
        it "includes no_results text" do
          get "/beta_participants"

          expect(response.body).to include(t("beta_participants.index.participant_list.no_results"))
        end
      end

      context "when private beta participant did not start a registration" do
        let(:beta_participant) { create(:beta_participant, reg_number: original_registration.reference) }

        before do
          beta_participant
        end

        it "includes completed registration details" do
          get "/beta_participants"

          expect(response.body).to include(original_registration.reference)
          expect(response.body).to include(beta_participant.email)
          expect(response.body).not_to include("View registration")
        end
      end

      context "when private beta participant started but not completed a registration" do
        let(:new_registration) { create(:new_registration, location: "England") }
        let(:beta_participant) { create(:beta_participant, reg_number: original_registration.reference, registration: new_registration) }

        before do
          beta_participant
        end

        it "includes completed registration details" do
          get "/beta_participants"

          expect(response.body).to include(original_registration.reference)
          expect(response.body).to include(beta_participant.email)
          expect(response.body).to include("in-progress-#{beta_participant.registration.id}")
          expect(response.body).to include("View registration")
        end
      end

      context "when private beta participant completed a registration" do
        let(:registration) { create(:registration) }
        let(:beta_participant) { create(:beta_participant, reg_number: original_registration.reference, registration: registration) }

        before do
          beta_participant
        end

        it "includes completed registration details" do
          get "/beta_participants"

          expect(response.body).to include(original_registration.reference)
          expect(response.body).to include(beta_participant.email)
          expect(response.body).to include(beta_participant.reg_number)
          expect(response.body).to include("View registration")
        end
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        get "/beta_participants"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
