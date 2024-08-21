# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Testing" do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "/create_registration" do
    let(:expiry_date) { 2.days.from_now.strftime("%Y-%m-%d") }

    context "when in a non-production environment" do
      before { allow(ENV).to receive(:fetch).with("AIRBRAKE_ENV_NAME", any_args).and_return("devwcr") }

      it "creates a registration" do
        expect { get "/testing/create_registration/#{expiry_date}" }.to change(WasteExemptionsEngine::Registration, :count).by(1)
      end

      it "creates a registration with default exemptions when no exemptions are specified" do
        get "/testing/create_registration/#{expiry_date}"
        expect(response).to have_http_status(:success)
        registration = WasteExemptionsEngine::Registration.last
        expect(registration.registration_exemptions.count).to eq(3)
      end

      it "creates a registration with specified exemptions" do
        exemption_codes = %w[U1 U2 U3]
        get "/testing/create_registration/#{expiry_date}", params: { exemptions: exemption_codes }
        expect(response).to have_http_status(:success)
        registration = WasteExemptionsEngine::Registration.last
        expect(registration.registration_exemptions.count).to eq(3)
        expect(registration.registration_exemptions.map { |re| re.exemption.code }).to match_array(exemption_codes)
      end

      it "sets the expiry date correctly" do
        get "/testing/create_registration/#{expiry_date}"
        expect(response).to have_http_status(:success)
        registration = WasteExemptionsEngine::Registration.last
        expect(registration.registration_exemptions.first.expires_on).to eq(Date.parse(expiry_date))
      end

      it "populates the edit_token_created_at" do
        get "/testing/create_registration/#{expiry_date}"
        expect(response).to have_http_status(:success)
        registration = WasteExemptionsEngine::Registration.last
        expect(registration.edit_token_created_at).to be_present
      end
    end

    context "when in a production environment" do
      before do
        allow(Rails.env).to receive(:test?).and_return(false)
        allow(ENV).to receive(:fetch).with("AIRBRAKE_ENV_NAME", any_args).and_return("production")
      end

      it "raises a routing error" do
        expect { get "/testing/create_registration/#{expiry_date}" }.to raise_error ActionController::RoutingError
      end
    end
  end
end
