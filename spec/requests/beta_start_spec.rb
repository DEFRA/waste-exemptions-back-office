# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Beta Start", type: :request do
  let(:registration) { create(:registration) }
  describe "GET /registrations/:reference/beta_start" do
    let(:request_path) { "/registrations/#{registration.reference}/beta_start" }

    before do
      sign_in(user) if defined?(user)
      WasteExemptionsEngine::FeatureToggle.create!(key: :private_beta, active: feature_active)
    end

    context "when private beta feature is active" do
      let(:feature_active) { true }

      shared_examples "allows access to beta start" do
        it "creates a new beta participant and redirects to the beta start form" do
          get request_path
          expect(WasteExemptionsEngine::BetaParticipant.count).to eq(1)
          participant = WasteExemptionsEngine::BetaParticipant.last
          expect(participant.email).to eq(registration.contact_email)
          path = WasteExemptionsEngine::Engine.routes.url_helpers.new_beta_start_form_path(participant.token)
          expect(response).to redirect_to(path)
        end
      end

      shared_examples "denies access to beta start" do
        it "redirects to permission page" do
          get request_path
          expect(response).to redirect_to("/pages/permission")
        end
      end

      context "when user is an admin team user" do
        let(:user) { create(:user, :admin_team_user) }
        include_examples "allows access to beta start"
      end

      context "when user is a customer service adviser" do
        let(:user) { create(:user, :customer_service_adviser) }
        include_examples "allows access to beta start"
      end

      context "when user is a developer" do
        let(:user) { create(:user, :developer) }
        include_examples "allows access to beta start"
      end

      context "when user is a service manager" do
        let(:user) { create(:user, :service_manager) }
        include_examples "allows access to beta start"
      end

      context "when user is an admin team lead" do
        let(:user) { create(:user, :admin_team_lead) }
        include_examples "allows access to beta start"
      end

      context "when user is a data viewer" do
        let(:user) { create(:user, :data_viewer) }
        include_examples "denies access to beta start"
      end

      context "when user is a policy adviser" do
        let(:user) { create(:user, :policy_adviser) }
        include_examples "denies access to beta start"
      end

      context "when user is a finance user" do
        let(:user) { create(:user, :finance_user) }
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

      it "redirects to permission page 404" do
        get request_path
        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
