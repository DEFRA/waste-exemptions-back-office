# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DefraQuarterlyStats" do

  describe "GET /quarterly_stats" do

    context "when a user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "returns HTTP status 200" do
        get quarterly_stats_path

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
