# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Testing" do

  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "/create_registration" do
    let(:expiry_date) { 2.days.from_now.strftime("%Y-%m-%d") }

    it "creates a registration" do
      expect { get "/testing/create_registration/#{expiry_date}" }.to change(WasteExemptionsEngine::Registration, :count).by(1)
    end
  end
end
