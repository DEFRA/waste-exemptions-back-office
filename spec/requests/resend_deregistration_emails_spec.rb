# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendDeregistrationEmails" do
  let(:registration) { create(:registration) }
  let(:referer) { "/" }

  describe "GET /resend-deregistration-emails/:id" do
    let(:request_path) { "/resend-deregistration-emails/#{registration.id}" }

    before do
      sign_in(user) if defined?(user)
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, :admin_agent) }

      context "when the service executed successfully" do
        before do
          allow(ResendDeregistrationEmailService).to receive(:run).and_return(true)
        end

        it "redirects back to the refering page" do
          get request_path, params: {}, headers: { "HTTP_REFERER" => referer }

          expect(response).to redirect_to(referer)

          expect(flash[:message]).to eq("Deregistration email(s) sent successfully")

          expect(ResendDeregistrationEmailService)
            .to have_received(:run).with(registration: registration)
        end
      end

      context "when the service failed" do
        before do
          allow(ResendDeregistrationEmailService).to receive(:run).and_return(false)
        end

        it "redirects back to the refering page" do
          get request_path, params: {}, headers: { "HTTP_REFERER" => referer }

          expect(response).to redirect_to(referer)

          expect(flash[:error]).to eq("Error sending deregistration email(s)")

          expect(ResendDeregistrationEmailService)
            .to have_received(:run).with(registration: registration)
        end
      end
    end

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_agent) }

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
