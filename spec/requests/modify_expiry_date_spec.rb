# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Modify Registration Date Forms" do
  let(:form) { ModifyExpiryDateForm.new }
  let(:user) { create(:user, :admin_team_user) }
  let(:registration) { create(:registration) }
  let(:original_registration_date) { registration.registration_exemptions.first.expires_on }

  before { sign_in(user) }

  shared_examples "not permitted" do
    it { expect(response.code).to eq(WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE.to_s) }
    it { expect(response.location).to include("/pages/permission") }
  end

  describe "GET /registrations/:id/modify_expiry_date_form" do

    before { get modify_expiry_date_form_path(registration.reference) }

    context "when the user is not a admin_team_user user" do
      let(:user) { create(:user, :data_viewer) }

      it_behaves_like "not permitted"
    end

    context "when the user is a admin_team_user user" do
      let(:user) { create(:user, :admin_team_user) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template("modify_expiry_date/new") }
    end
  end

  describe "POST /registrations/:id/modify_expiry_date" do
    let(:new_expiry_date) { 6.months.from_now }
    let(:request_body) { {} }

    before { post modify_expiry_date_path(registration.reference), params: request_body }

    context "when the user is not a admin_team_user user" do
      let(:user) { create(:user, :data_viewer) }

      it_behaves_like "not permitted"
    end

    context "when the user is a admin_team_user user" do
      let(:user) { create(:user, :admin_team_user) }

      context "when the form is not valid" do
        let(:request_body) do
          { modify_expiry_date_form: { date_day: "45", date_month: "5", date_year: "2030" } }
        end

        it "responds with a 200 status code" do
          expect(response).to have_http_status(:ok)
        end

        it "renders the same template" do
          expect(response).to render_template("modify_expiry_date/new")
        end
      end

      context "when the form is valid" do
        let(:request_body) do
          { modify_expiry_date_form: {
            date_day: new_expiry_date.day,
            date_month: new_expiry_date.month,
            date_year: new_expiry_date.year,
            reason_for_change: "extending expiry date"
          } }
        end

        context "when the date is in the past" do
          let(:new_expiry_date) { 6.months.ago }

          it "renders the same template" do
            expect(response).to render_template("modify_expiry_date/new")
          end

          it "includes the expected error message" do
            expect(response.body).to include I18n.t("modify_expiry_date.errors.not_future")
          end

          it "does not modify the expiry date" do
            registration.registration_exemptions.each do |e|
              expect(e.expires_on).to eq original_registration_date
            end
          end
        end

        context "when the date is in the future" do
          let(:new_expiry_date) { 1.month.from_now }

          it "renders the registration template" do
            expect(response.location).to include("registrations/#{registration.reference}")
          end

          it "responds with a successful redirect status code" do
            expect(response.code).to eq WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE.to_s
          end

          it "updates the registration exemptions expiry dates" do
            registration.reload.registration_exemptions.each do |e|
              expect(e.expires_on.to_date).to eq new_expiry_date.to_date
            end
          end
        end
      end
    end
  end
end
