# frozen_string_literal: true

require "rails_helper"

module Analytics
  RSpec.describe "Analytics average time per page" do
    let(:role) { "data_viewer" }
    let(:user) { create(:user, role: role) }

    let(:start_date_param) { "2025-01-01" }
    let(:end_date_param) { "2025-01-31" }

    # These values are required by the shared_context
    let(:start_date) { Date.parse(start_date_param) }
    let(:end_date) { Date.parse(end_date_param) }

    # All within the date range
    let(:created_at) { start_date + 1.day }

    # Set a fixed time value from which to start measuring page times
    let(:start_time) { 1.week.ago }

    include_context "with user journeys with timed page views"

    before { sign_in(user) }

    describe "GET /analytics_average_time_per_pages" do

      context "when user does not have permission to view analytics" do
        let(:role) { "data_viewer" }

        it "raises an authorization error" do
          get analytics_average_time_per_pages_path,
              params: { start_date: start_date_param, end_date: end_date_param }
          expect(response).to redirect_to("/pages/permission")
        end
      end

      context "when user has permission to view analytics" do
        let(:role) { "admin_team_user" }

        before do
          get analytics_average_time_per_pages_path,
              params: { start_date: start_date_param, end_date: end_date_param }
        end

        it "returns HTTP status 200" do
          expect(response).to have_http_status(:ok)
        end

        it "renders the index template" do
          expect(response).to render_template(:index)
        end

        it "presents the expected number of page names" do
          # This just checks for the sorted presence of the page name on the page;
          # detailed testing of average page time logic is covered in the service spec.
          expect(response.body).to match(/location.*operator-name.*beta-start/m)
        end
      end
    end
  end
end
