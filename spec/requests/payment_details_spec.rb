# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payment details" do
  describe "GET /registrations/:reference/payment_details" do
    let(:registration) { create(:registration, account: build(:account, :with_order, :with_payment)) }
    let(:account) { registration.account }
    let(:order) { account.orders.first }
    let(:i18n_page) { ".payment_details.index" }
    let(:i18n_actions_section) { "#{i18n_page}.actions_section" }

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get registration_payment_details_path(registration.reference)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
        get registration_payment_details_path(registration.reference)
      end

      it "renders the show template" do
        expect(response).to render_template(:index)
      end

      it "includes the correct reference" do
        expect(response.body).to include(registration.reference)
      end

      context "for the details section" do
        let(:i18n_details_section) { "#{i18n_page}.details_section" }

        it { expect(response).to have_http_status(:ok) }

        it { expect(response.body).to include I18n.t("#{i18n_page}.heading", reference: registration.reference) }

        # charges
        it { expect(response.body).to include I18n.t("#{i18n_details_section}.charges.heading") }

        it "includes the expected charges table headers" do
          aggregate_failures do
            expect(response.body).to include I18n.t("#{i18n_details_section}.charges.headers.date")
            expect(response.body).to include I18n.t("#{i18n_details_section}.charges.headers.breakdown")
            expect(response.body).to include I18n.t("#{i18n_details_section}.charges.headers.amount")
          end
        end

        it "includes charge details" do
          expected_exemption_codes = order.exemptions.pluck(:code).sort
          expect(response.body).to include expected_exemption_codes.join(",")
        end

        it { expect(response.body).to include I18n.t("#{i18n_details_section}.charges.registration_charge_label") }
        it { expect(response.body).to include I18n.t("#{i18n_details_section}.charges.total_charge_label") }

        # charge adjustments
        it { expect(response.body).to include I18n.t("#{i18n_details_section}.charge_adjustments.heading") }

        it "includes the expected charge adjustments table headers" do
          aggregate_failures do
            expect(response.body).to include I18n.t("#{i18n_details_section}.charge_adjustments.headers.date")
            expect(response.body).to include I18n.t("#{i18n_details_section}.charge_adjustments.headers.type")
            expect(response.body).to include I18n.t("#{i18n_details_section}.charge_adjustments.headers.comments")
            expect(response.body).to include I18n.t("#{i18n_details_section}.charge_adjustments.headers.amount")
          end
        end

        # payments
        it { expect(response.body).to include I18n.t("#{i18n_details_section}.payments.heading") }

        it "includes the expected payments table headers" do
          aggregate_failures do
            expect(response.body).to include I18n.t("#{i18n_details_section}.payments.headers.date")
            expect(response.body).to include I18n.t("#{i18n_details_section}.payments.headers.reference")
            expect(response.body).to include I18n.t("#{i18n_details_section}.payments.headers.type")
            expect(response.body).to include I18n.t("#{i18n_details_section}.payments.headers.amount")
          end
        end

        it "includes payment details" do
          expect(response.body).to include account.payments.first.reference
        end

        # refunds
        it { expect(response.body).to include I18n.t("#{i18n_details_section}.refunds.heading") }

        it "includes the expected refund table headers" do
          aggregate_failures do
            expect(response.body).to include I18n.t("#{i18n_details_section}.refunds.headers.date")
            expect(response.body).to include I18n.t("#{i18n_details_section}.refunds.headers.reference")
            expect(response.body).to include I18n.t("#{i18n_details_section}.refunds.headers.comments")
            expect(response.body).to include I18n.t("#{i18n_details_section}.refunds.headers.amount")
          end
        end

        # balance
        it { expect(response.body).to include I18n.t("#{i18n_details_section}.balance.heading") }
        it { expect(response.body).to include I18n.t("#{i18n_details_section}.balance.amount") }
        it { expect(response.body).to include (registration.account.balance / 100).round(2).to_s }
      end

      it { expect(response.body).to include I18n.t("#{i18n_actions_section}.heading", reference: registration.reference) }

    end

    describe "reverse payment link" do
      let(:payment) do
        create(:payment,
               payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_BANK_TRANSFER,
               payment_status: "success",
               account:)
      end

      before do
        sign_in(user)

        account.payments << payment

        get registration_payment_details_path(registration.reference)
      end

      context "when user does not have reverse_payment permission" do
        let(:user) { create(:user) }

        it "does not display the reverse payment link" do
          expect(response.body).not_to include(I18n.t("#{i18n_actions_section}.links.reverse_payment"))
        end
      end

      context "when user has reverse_payment permission" do
        let(:user) { create(:user, :developer) }

        it "displays the reverse payment link" do
          expect(response.body).to include(I18n.t("#{i18n_actions_section}.links.reverse_payment"))
        end
      end
    end
  end
end
