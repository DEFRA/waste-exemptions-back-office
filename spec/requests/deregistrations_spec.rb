# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deregistrations" do
  let(:registration) { create(:registration, :with_active_exemptions) }

  describe "GET #show" do
    context "when a user is signed in" do
      before do
        sign_in(create(:user))
      end

      it "renders the show template and includes the correct reference" do
        get deregistration_path(registration.reference)

        expect(response).to render_template(:show)
        expect(response.body).to include(registration.reference)
      end

      it "includes the correct back link" do
        get deregistration_path(registration.reference)

        expect(response.body).to include(registration_path(registration.reference))
      end

      it "shows all deregistered exemptions for the registration" do
        exemption1 = registration.registration_exemptions.first
        exemption1.update(state: "revoked", deregistered_at: Time.zone.now)

        exemption2 = registration.registration_exemptions.second
        exemption2.update(state: "ceased", deregistered_at: Time.zone.now)

        get deregistration_path(registration.reference)

        expect(response.body).to include(exemption1.exemption.code)
        expect(response.body).to include(exemption2.exemption.code)
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get deregistration_path(registration.reference)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
