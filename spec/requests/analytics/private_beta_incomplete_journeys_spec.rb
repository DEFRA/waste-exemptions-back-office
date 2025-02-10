# frozen_string_literal: true

require "rails_helper"

module Analytics
  RSpec.describe "Private beta incomplete journeys" do
    let(:role) { "data_viewer" }
    let(:user) { create(:user, role: role) }

    let(:start_date_param) { "2023-01-01" }
    let(:end_date_param) { "2023-01-31" }

    before do
      create_list(:user_journey, 2, :charged_registration,
                  created_at: Date.parse(start_date_param) + 1.day,
                  updated_at: 5.days.ago,
                  visited_pages: %w[location_form declaration_form])
      create_list(:user_journey, 3, :charged_registration,
                  created_at: Date.parse(end_date_param) - 1.day,
                  updated_at: 3.days.ago,
                  visited_pages: %w[location_form operator_name_form])
      sign_in(user)
    end

    describe "GET /private_beta_incomplete_journeys" do
      before do
        get private_beta_incomplete_journeys_path,
            params: { start_date: start_date_param, end_date: end_date_param }
      end

      context "when user does not have permission to view analytics" do
        let(:role) { "data_viewer" }

        it "raises an authorization error" do
          expect(response).to redirect_to("/pages/permission")
        end
      end

      context "when user has permission to view analytics" do
        let(:role) { "admin_team_user" }

        it "returns HTTP status 200" do
          expect(response).to have_http_status(:ok)
        end

        it "renders the index template" do
          expect(response).to render_template(:index)
        end

        it "presents the expected number of declaration_form pages" do
          # This just checks for the sorted presence of the page name and count on the page;
          # detailed testing of the page counting logic is covered in the service spec.
          expect(response.body).to match(/operator-name.*3.*declaration.*6/m)
        end
      end
    end
  end
end
