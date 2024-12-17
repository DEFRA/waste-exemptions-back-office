# frozen_string_literal: true

require "rails_helper"

RSpec.describe "sendEditInviteEmails" do
  let(:notifications_client) { instance_double(Notifications::Client) }
  let(:registration) { create(:registration) }
  let(:referer) { "/" }

  describe "GET /send-edit-invite-emails/:id" do
    let(:request_path) { "/send-edit-invite-emails/#{registration.id}" }

    before { sign_in(user) if defined?(user) }

    context "when a valid user is signed in" do
      let(:user) { create(:user, :customer_service_adviser) }

      context "when the service executes successfully" do
        before do
          allow(WasteExemptionsEngine::RegistrationEditLinkEmailService).to receive(:run).with(anything).and_call_original
          allow(Notifications::Client).to receive(:new).and_return(notifications_client)
          allow(notifications_client).to receive(:send_email).and_return(true)
        end

        # Bullet appears confused about eager-loading `registration_exemptions: :exemption`
        # and `Bullet.unused_eager_loading_enable = false` does not disable it here, so turn it off and on again
        around do |example|
          Bullet.enable = false

          example.run

          Bullet.enable = true
        end

        it "calls the service and redirects back to the refering page with a success message" do
          get request_path, params: {}, headers: { "HTTP_REFERER" => referer }

          expect(WasteExemptionsEngine::RegistrationEditLinkEmailService)
            .to have_received(:run).with(hash_including(registration: registration))

          expect(response).to redirect_to(referer)

          expect(flash[:message]).to eq("Edit invite email sent successfully")
        end
      end

      context "when the service fails" do
        before do
          allow(WasteExemptionsEngine::RegistrationEditLinkEmailService).to receive(:run).and_return(false)
        end

        it "calls the service and redirects back to the refering page with a flash error message" do
          get request_path, params: {}, headers: { "HTTP_REFERER" => referer }

          expect(WasteExemptionsEngine::RegistrationEditLinkEmailService)
            .to have_received(:run).with(hash_including(registration: registration))

          expect(response).to redirect_to(referer)

          expect(flash[:error]).to eq("Error sending edit invite email")
        end
      end

      context "when the registration has no contact email" do
        let(:registration) { create(:registration, contact_email: nil) }

        it "redirects back to the refering page with a flash error message" do
          get request_path, params: {}, headers: { "HTTP_REFERER" => referer }

          expect(response).to redirect_to(referer)

          expect(flash[:error]).to eq("Sorry, there has been a problem re-sending the edit invite email.")
          expect(flash[:error_details]).to eq("You have requested to resend a edit invite email to the contact email address, but this address is missing from the registration.")
        end
      end
    end

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_viewer) }

      it "redirects to permission page" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => referer }
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => referer }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
