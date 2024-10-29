# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payment details" do
  describe "GET /registrations/:id/payment_details" do
    let(:registration) { create(:registration, account: build(:account)) }
    let(:i18n_page) { ".payment_details.index" }

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get registration_payment_details_path(registration.reference)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a valid user is signed in" do

      before do
        sign_in(create(:user))

        get registration_payment_details_path(registration.reference)
      end

      # actions section
      let(:i18n_details_section) { "#{i18n_page}.details_section" }
      let(:i18n_actions_section) { "#{i18n_page}.actions_section" }
      let(:i18n_details_charges) { "#{i18n_details_section}.charges" }
      let(:i18n_details_payments) { "#{i18n_details_section}.payments" }
      let(:i18n_details_refunds) { "#{i18n_details_section}.refunds" }
      let(:i18n_details_balance) { "#{i18n_details_section}.balance" }

      it { expect(response).to have_http_status(:ok) }

      it { expect(response.body).to include I18n.t("#{i18n_page}.heading", reference: registration.reference) }

      it { expect(response.body).to include I18n.t("#{i18n_details_charges}.heading") }

      it "includes the expected charges table headers" do
        aggregate_failures do
          expect(response.body).to include I18n.t("#{i18n_details_charges}.headers.date")
          expect(response.body).to include I18n.t("#{i18n_details_charges}.headers.type")
          expect(response.body).to include I18n.t("#{i18n_details_charges}.headers.reason")
          expect(response.body).to include I18n.t("#{i18n_details_charges}.headers.amount")
        end
      end

      it { expect(response.body).to include I18n.t("#{i18n_details_payments}.heading") }

      it "includes the expected payments table headers" do
        aggregate_failures do
          expect(response.body).to include I18n.t("#{i18n_details_payments}.headers.date")
          expect(response.body).to include I18n.t("#{i18n_details_payments}.headers.reference")
          expect(response.body).to include I18n.t("#{i18n_details_payments}.headers.type")
          expect(response.body).to include I18n.t("#{i18n_details_payments}.headers.amount")
        end
      end

      it { expect(response.body).to include I18n.t("#{i18n_details_refunds}.heading") }

      it "includes the expected refund table headers" do
        aggregate_failures do
          expect(response.body).to include I18n.t("#{i18n_details_refunds}.headers.date")
          expect(response.body).to include I18n.t("#{i18n_details_refunds}.headers.reference")
          expect(response.body).to include I18n.t("#{i18n_details_refunds}.headers.reason")
          expect(response.body).to include I18n.t("#{i18n_details_refunds}.headers.amount")
        end
      end

      it { expect(response.body).to include I18n.t("#{i18n_details_balance}.heading") }
      it { expect(response.body).to include I18n.t("#{i18n_details_balance}.amount") }
      it { expect(response.body).to include (registration.account.balance / 100).round(2).to_s }

      it { expect(response.body).to include I18n.t("#{i18n_actions_section}.heading", reference: registration.reference) }
    end
  end
end
