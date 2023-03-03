# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DeregistrationEmailExport" do
  let(:registration) { create(:registration, :eligible_for_deregistration) }

  describe "GET /deregistration_email_exports/new" do
    let(:request_path) { new_deregistration_email_export_path }

    before do
      sign_in(user) if defined?(user)

      get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
    end

    context "when signed in" do
      let(:user) { create(:user, :developer) }

      it "renders the correct template" do
        expect(response.code).to eq("200")
        expect(response).to render_template("new")
      end
    end

    context "when not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /deregistration_email_exports" do
    let(:request_path) { deregistration_email_exports_path }

    before do
      sign_in(user) if defined?(user)
    end

    context "when signed in" do
      let(:user) { create(:user, :developer) }

      let(:batch_size) { 200 }

      let(:params) do
        {
          deregistration_email_exports_form: {
            batch_size: batch_size
          }
        }
      end

      before do
        allow(Reports::DeregistrationEmailBatchExportService)
          .to receive(:run).with(batch_size: batch_size).and_return(service_state)

        post request_path, params: params, headers: { "HTTP_REFERER" => "/" }
      end

      context "when successful" do
        let(:service_state) { true }

        it "redirects to the dashboard" do
          expect(response.code).to eq("302")
          expect(response).to redirect_to(root_path)
        end
      end

      context "when not successful" do
        let(:service_state) { false }

        it "renders the new template" do
          expect(response.code).to eq("200")
          expect(response).to render_template("new")
        end
      end
    end

    context "when not signed in" do
      before do
        sign_out(create(:user))

        post request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
      end

      it "redirects to the sign-in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
