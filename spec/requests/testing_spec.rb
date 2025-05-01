# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Testing" do
  let(:user) { create(:user) }
  let(:registration) { WasteExemptionsEngine::Registration.last }

  before { sign_in(user) }

  after do
    allow(ENV).to receive(:fetch).with("AIRBRAKE_ENV_NAME", any_args).and_call_original
    allow(Rails.env).to receive(:test?).and_call_original
  end

  describe "/create_registration" do
    let(:expiry_date) { 2.days.from_now.strftime("%Y-%m-%d") }

    context "when in a non-production environment" do
      before { allow(ENV).to receive(:fetch).with("AIRBRAKE_ENV_NAME", any_args).and_return("devwcr") }

      it "creates a registration" do
        expect { get "/testing/create_registration/#{expiry_date}" }.to change(WasteExemptionsEngine::Registration, :count).by(1)
      end

      it "responds with HTTP success" do
        get "/testing/create_registration/#{expiry_date}"

        expect(response).to have_http_status(:success)
      end

      it "creates a registration with default exemptions when no exemptions are specified" do
        get "/testing/create_registration/#{expiry_date}"

        expect(registration.registration_exemptions.count).to eq(3)
      end

      it "only creates registration exemptions for existing exemption codes" do
        existing_exemption1 = create(:exemption, code: "U1")
        existing_exemption2 = create(:exemption, code: "U2")
        non_existing_code = "U99"
        exemption_codes = [existing_exemption1.code, existing_exemption2.code, non_existing_code]

        expect do
          get "/testing/create_registration/#{expiry_date}", params: { exemptions: exemption_codes }
        end.not_to change(WasteExemptionsEngine::Exemption, :count)

        expect(registration.registration_exemptions.count).to eq(2)
        expect(registration.registration_exemptions.map { |re| re.exemption.code }).to contain_exactly(existing_exemption1.code, existing_exemption2.code)
        expect(WasteExemptionsEngine::Exemption.find_by(code: non_existing_code)).to be_nil
      end

      it "creates a registration with specified exemptions" do
        exemption_codes = [create(:exemption, code: "U1"), create(:exemption, code: "U2"), create(:exemption, code: "U3")].map(&:code)
        get "/testing/create_registration/#{expiry_date}", params: { exemptions: exemption_codes }

        expect(registration.registration_exemptions.count).to eq(3)
        expect(registration.registration_exemptions.map { |re| re.exemption.code }).to match_array(exemption_codes)
      end

      it "sets the expiry date correctly" do
        get "/testing/create_registration/#{expiry_date}"

        expect(registration.registration_exemptions.first.expires_on).to eq(Date.parse(expiry_date))
      end

      it "populates the edit_token_created_at" do
        get "/testing/create_registration/#{expiry_date}"

        expect(registration.edit_token_created_at).to be_present
      end

      it "creates an order" do
        get "/testing/create_registration/#{expiry_date}"

        expect(registration.account.orders.length).to eq 1
      end

      it "calculates the account balance" do
        get "/testing/create_registration/#{expiry_date}"

        expect(registration.account.balance).to be_negative
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
