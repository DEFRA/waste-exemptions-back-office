# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Communication Logs" do
  let(:registration) { create(:registration) }
  let(:user) { create(:user, role: :admin_agent) }

  before do
    sign_in(user)
  end

  describe "GET /bo/registrations/:reference/communication_logs/" do
    context "when communication history is present" do
      it "renders the index template, returns a 200 response and includes the correct content" do
        email = create(:registration_communication_log, :email, registration: registration)
        letter = create(:registration_communication_log, :letter, registration: registration)
        text = create(:registration_communication_log, :text, registration: registration)

        get "/registrations/#{registration.reference}/communication_logs"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Communication history")
        expect(response.body).to include(email.communication_log.sent_to)
        expect(response.body).to include(letter.communication_log.sent_to)
        expect(response.body).to include(text.communication_log.sent_to)
      end
    end

    context "when communication history is empty" do
      it "renders the index template, returns a 200 response and includes the correct content" do
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
end
