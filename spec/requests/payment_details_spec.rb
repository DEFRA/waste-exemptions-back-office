# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payment Details" do
  let(:registration) { create(:registration) }

  describe "GET /registrations/:reference/payment_details" do
    context "when a user is signed in" do
      before do
        sign_in(create(:user))
      end

      it "renders the show template and includes the correct reference" do
        get "/registrations/#{registration.reference}/payment_details"

        expect(response).to render_template(:index)
        expect(response.body).to include(registration.reference)
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/registrations/#{registration.id}"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
