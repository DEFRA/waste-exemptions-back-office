# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendConfirmationLetter" do
  let(:registration) { create(:registration) }

  describe "GET /resend-confirmation-letter/:reference" do
    let(:request_path) { "/resend-confirmation-letter/#{registration.reference}" }

    before { sign_in(user) if defined?(user) }

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_agent) }

      it "redirects to permission page" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when an admin agent user is signed in" do
      let(:user) { create(:user, :admin_agent) }

      it "returns a 200 code and includes the correct data" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

        expect(response.code).to eq("200")
        expect(response.body).to include(registration.contact_address.postcode)
      end
    end
  end

  describe "POST /resend-confirmation-letter/:reference" do
    let(:request_path) { "/resend-confirmation-letter/#{registration.reference}" }

    before { sign_in(user) if defined?(user) }

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_agent) }

      it "redirects to permission page" do
        post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when an admin agent user is signed in" do
      let(:user) { create(:user, :admin_agent) }

      it "return a 302 redirect code" do
        VCR.use_cassette("notify_confirmation_letter") do
          post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

          expect(response.code).to eq("302")
        end
      end

      it "return a success message" do
        VCR.use_cassette("notify_confirmation_letter") do
          success_message = I18n.t("resend_confirmation_letter.messages.success", reference: registration.reference)

          post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
          follow_redirect!

          expect(response.body).to include(success_message)
        end
      end

      context "when an error happens", disable_bullet: true do
        before do
          allow(WasteExemptionsEngine::NotifyConfirmationLetterService).to receive(:run).and_raise(StandardError)
        end

        it "return a 302 redirect code" do
          post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

          expect(response.code).to eq("302")
        end

        it "return an error message" do
          error_message = I18n.t("resend_confirmation_letter.messages.failure_details")

          post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
          follow_redirect!

          expect(response.body).to include(error_message)
        end
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
