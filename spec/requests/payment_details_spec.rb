# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payment details" do
  describe "GET /registrations/:id/payment_details" do
    let(:registration) { create(:registration, account: build(:account)) }
    let(:payment_details_route) { registration_payment_details_path(registration.reference) }
    let(:i18n_page) { ".payment_details.index" }

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get payment_details_route

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a valid user is signed in" do

      before do
        sign_in(create(:user))

        get payment_details_route
      end

      it { expect(response).to have_http_status(:ok) }

      it { expect(response.body).to include I18n.t("#{i18n_page}.heading", reference: registration.reference) }

      # details section
      let(:i18n_details_section) { "#{i18n_page}.details_section" }

      # charges
      let(:i18n_details_charges) { "#{i18n_details_section}.charges" }
      let(:i18n_charge_headers) { "#{i18n_details_charges}.headers" }
      it { expect(response.body).to include I18n.t("#{i18n_details_charges}.heading") }
      it "includes the expected charges table headers" do
        aggregate_failures do
          expect(response.body).to include I18n.t("#{i18n_charge_headers}.date")
          expect(response.body).to include I18n.t("#{i18n_charge_headers}.type")
          expect(response.body).to include I18n.t("#{i18n_charge_headers}.reason")
          expect(response.body).to include I18n.t("#{i18n_charge_headers}.amount")
        end
      end

      # payments
      let(:i18n_details_payments) { "#{i18n_details_section}.payments" }
      let(:i18n_payment_headers) { "#{i18n_details_payments}.headers" }
      it { expect(response.body).to include I18n.t("#{i18n_details_payments}.heading") }
      it "includes the expected payments table headers" do
        aggregate_failures do
          expect(response.body).to include I18n.t("#{i18n_payment_headers}.date")
          expect(response.body).to include I18n.t("#{i18n_payment_headers}.reference")
          expect(response.body).to include I18n.t("#{i18n_payment_headers}.type")
          expect(response.body).to include I18n.t("#{i18n_payment_headers}.amount")
        end
      end

      # refunds
      let(:i18n_details_refunds) { "#{i18n_details_section}.refunds" }
      let(:i18n_refund_headers) { "#{i18n_details_refunds}.headers" }
      it { expect(response.body).to include I18n.t("#{i18n_details_refunds}.heading") }
      it "includes the expected payments table headers" do
        aggregate_failures do
          expect(response.body).to include I18n.t("#{i18n_refund_headers}.date")
          expect(response.body).to include I18n.t("#{i18n_refund_headers}.reference")
          expect(response.body).to include I18n.t("#{i18n_refund_headers}.reason")
          expect(response.body).to include I18n.t("#{i18n_refund_headers}.amount")
        end
      end

      # balance
      let(:i18n_details_balance) { "#{i18n_details_section}.balance" }
      it { expect(response.body).to include I18n.t("#{i18n_details_balance}.heading") }
      it { expect(response.body).to include I18n.t("#{i18n_details_balance}.amount") }
      it { expect(response.body).to include ((registration.account.balance/100).round(2)).to_s }

      # actions section
      let(:i18n_actions_section) { "#{i18n_page}.actions_section" }
      it { expect(response.body).to include I18n.t("#{i18n_actions_section}.heading") }
    end
  end
end
