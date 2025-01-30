# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Beta Start" do
  let(:registration) { create(:registration) }

  describe "GET /registrations/:reference/beta_start" do
    let(:request_path) { "/registrations/#{registration.reference}/beta_start" }

    before do
      sign_in(user) if defined?(user)
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:private_beta).and_return(feature_active)
    end

    context "when private beta feature is active" do
      let(:feature_active) { true }

      shared_examples "allows access to beta start" do
        context "when the beta participant already exists" do
          let!(:participant) { create(:beta_participant, email: registration.contact_email, reg_number: registration.reference) }

          it "redirects to the beta start form" do
            get request_path
            path = WasteExemptionsEngine::Engine.routes.url_helpers.new_beta_start_form_path(participant.token)
            expect(response).to redirect_to(path)
          end
        end

        it "creates a new beta participant and redirects to the beta start form" do
          Timecop.freeze(Time.current) do
            get request_path
            expect(WasteExemptionsEngine::BetaParticipant.count).to eq(1)
            participant = WasteExemptionsEngine::BetaParticipant.last
            expect(participant.email).to eq(registration.contact_email)
            expect(participant.invited_at).to be_within(1.second).of(Time.current)
            path = WasteExemptionsEngine::Engine.routes.url_helpers.new_beta_start_form_path(participant.token)
            expect(response).to redirect_to(path)
          end
        end
      end

      shared_examples "denies access to beta start" do
        it "redirects to permission page" do
          get request_path
          expect(response).to redirect_to("/pages/permission")
        end
      end

      context "when user has permission to access" do
        let(:user) { create(:user, :admin_team_user) }

        include_examples "allows access to beta start"
      end

      context "when user does not have permission to access" do
        let(:user) { create(:user, :data_viewer) }

        include_examples "denies access to beta start"
      end

      context "when user is not signed in" do
        before { sign_out(create(:user)) }

        it "redirects to the sign-in page" do
          get request_path
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context "when private beta feature is not active" do
      let(:feature_active) { false }
      let(:user) { create(:user, :admin_team_user) }

      it "tells user feature flag is not active" do
        get request_path
        expect(response).to redirect_to(registration_path(registration.reference))
        expect(flash[:error]).to eq(I18n.t("beta_start.messages.feature_not_active"))
      end
    end
  end
end
