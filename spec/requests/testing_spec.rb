# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Testing" do

  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "/create_registration" do
    let(:expiry_date) { 2.days.from_now.strftime("%Y-%m-%d") }

    context "when in a non-production environment" do
      before { stub_const("ENV", ENV.to_hash.merge("AIRBRAKE_ENV_NAME" => "devwex")) }

      it "creates a registration" do
        expect { get "/testing/create_registration/#{expiry_date}" }.to change(WasteExemptionsEngine::Registration, :count).by(1)
      end
    end

    context "when in a production environment" do
      before do
        allow(Rails.env).to receive(:test?).and_return(false)
        stub_const("ENV", ENV.to_hash.merge("AIRBRAKE_ENV_NAME" => "production"))
      end

      it "raises an error" do
        get "/testing/create_registration/#{expiry_date}"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
