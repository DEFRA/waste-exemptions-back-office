# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SendPrivateBetaInviteEmail" do
  let(:registration) { create(:registration) }

  describe "GET /send-private-beta-invite-email/:reference" do
    let(:request_path) { "/send-private-beta-invite-email/#{registration.reference}" }

    before do
      sign_in(user) if defined?(user)
      allow(PrivateBetaInviteEmailService).to receive(:run)
    end

    context "when a user without permission is signed in" do
      let(:user) { create(:user, :data_viewer) }

      it "redirects to permission page" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when a user with permission is signed in", :disable_bullet do
      let(:user) { create(:user, :admin_team_lead) }

      around do |example|
        # Bullet can't make up its mind about whether or not we should eager-load
        # `registration_exemptions: :exemption` - if we have it, it tells us to
        # remove it, and if we don't have it, it tells us to add it.
        # In this case we're leaving it in and telling Bullet to pipe down.
        Bullet.unused_eager_loading_enable = false

        example.run

        Bullet.unused_eager_loading_enable = true
      end

      it "returns a success message" do
        VCR.use_cassette("send_private_beta_invite_email") do
          success_message = I18n.t("send_private_beta_invite_email.messages.success",
                                   email: registration.contact_email)

          get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
          follow_redirect!

          expect(response.body).to include(success_message)
        end
      end

      context "when an error happens" do
        before do
          allow(PrivateBetaInviteEmailService).to receive(:run).and_raise(StandardError)
        end

        it "returns an error message" do
          error_message = I18n.t("send_private_beta_invite_email.messages.failure_details")

          get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
          follow_redirect!

          expect(response.body).to include(error_message)
        end
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
