# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendRenewalLetter" do
  let(:registration) { create(:registration) }

  describe "GET /resend-renewal-letter/:reference" do
    let(:request_path) { "/resend-renewal-letter/#{registration.reference}" }

    before { sign_in(user) if defined?(user) }

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_viewer) }

      it "redirects to permission page" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when an admin agent user is signed in" do
      let(:user) { create(:user, :customer_service_adviser) }

      it "returns a 200 code and includes the correct data" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(registration.contact_address.postcode)
      end
    end
  end

  describe "POST /resend-renewal-letter/:reference" do
    let(:request_path) { "/resend-renewal-letter/#{registration.reference}" }

    before { sign_in(user) if defined?(user) }

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_viewer) }

      it "redirects to permission page" do
        post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when an admin agent user is signed in" do
      let(:user) { create(:user, :customer_service_adviser) }

      it "return a 302 redirect code" do
        VCR.use_cassette("notify_renewal_letter") do
          post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

          expect(response).to have_http_status(:found)
        end
      end

      it "return a success message" do
        VCR.use_cassette("notify_renewal_letter") do
          success_message = I18n.t("resend_renewal_letter.messages.success", reference: registration.reference)

          post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
          follow_redirect!

          expect(response.body).to include(success_message)
        end
      end

      context "when an error happens", :disable_bullet do
        before do
          allow(RenewalReminders::RenewalLetterService).to receive(:run).and_raise(StandardError)
        end

        it "return a 302 redirect code" do
          post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

          expect(response).to have_http_status(:found)
        end

        it "return an error message" do
          error_message = I18n.t("resend_renewal_letter.messages.failure_details")

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
