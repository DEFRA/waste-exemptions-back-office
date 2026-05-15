# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Communication Logs" do
  let(:registration) { create(:registration) }
  let(:user) { create(:user, role: :customer_service_adviser) }

  before do
    sign_in(user)
  end

  describe "GET /registrations/:reference/communication_logs" do
    context "when communication history is present" do
      it "renders the index template with linked titles and delivery status" do
        email_log = create(:registration_communication_log, :email, registration: registration)

        get "/registrations/#{registration.reference}/communication_logs"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Communication history")
        expect(response.body).to include(email_log.communication_log.template_label)
        expect(response.body).to include(email_log.communication_log.message_type)
      end
    end

    context "when communication history is empty" do
      it "renders the index template with no results message" do
        get "/registrations/#{registration.reference}/communication_logs"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Communication history")
        expect(response.body).to include("No results found")
      end
    end

    context "when user has no access or registration does not exist" do
      it "redirects to the permissions page" do
        get "/registrations/NOT-EXISTING/communication_logs"

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "GET /registrations/:reference/communication_logs/:id" do
    let(:email_log) { create(:registration_communication_log, :email, registration: registration) }

    context "when the communication log exists" do
      it "renders the show template with communication details" do
        get "/registrations/#{registration.reference}/communication_logs/#{email_log.communication_log.id}"

        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Communication history")
        expect(response.body).to include(email_log.communication_log.template_label)
        expect(response.body).to include(email_log.communication_log.template_id)
        expect(response.body).to include(email_log.communication_log.message_type)
        expect(response.body).to include(email_log.communication_log.sent_to)
      end
    end

    context "when the communication log has content" do
      let(:email_with_content) do
        create(:communication_log, :email_with_content).tap do |log|
          create(:registration_communication_log, registration: registration, communication_log: log)
        end
      end

      it "displays the email body content" do
        get "/registrations/#{registration.reference}/communication_logs/#{email_with_content.id}"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Your registration is complete.")
      end
    end

    context "when the communication log has no content" do
      it "displays 'Not available' for missing fields" do
        get "/registrations/#{registration.reference}/communication_logs/#{email_log.communication_log.id}"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Not available")
      end
    end

    context "when user has no access or registration does not exist" do
      it "redirects to the permissions page" do
        get "/registrations/NOT-EXISTING/communication_logs/#{email_log.communication_log.id}"

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
