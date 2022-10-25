# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Assisted digital privacy policy" do
  let(:user) { create(:user, :system) }

  before do
    sign_in(user)
  end

  describe "GET /ad-privacy-policy" do
    it "renders the correct template and responds with a 200 status code" do
      get ad_privacy_policy_path

      expect(response).to render_template("ad_privacy_policy/show")
      expect(response.code).to eq("200")
    end
  end
end
