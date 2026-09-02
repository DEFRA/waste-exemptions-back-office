# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registration Non-Payments Controller" do
  let(:user) { create(:user, :developer) }

  let!(:registration) do
    registration = create(:registration,
                          registration_exemptions: build_list(:registration_exemption, 1, :active),
                          operator_name: "Anna-Kay Williams",
                          submitted_at: 70.days.ago.to_date)
    registration.account.orders << create(:order,
                                          charge_detail: build(:charge_detail,
                                                               registration_charge_amount: 8_800,
                                                               band_charge_details: []))
    registration
  end

  before { sign_in(user) }

  describe "GET /registration-non-payments" do
    it "renders the list of registrations owing money" do
      get registration_non_payments_path

      expect(response).to have_http_status(:ok)
      expect(response).to render_template("registration_non_payments/index")
      expect(assigns(:registrations)).to contain_exactly(registration)
      expect(response.body).to include("Anna-Kay Williams")
      expect(response.body).to include("£88")
      expect(response.body).to include("70 days")
    end

    it "links each registration to its payment details page" do
      get registration_non_payments_path

      expect(response.body).to include(
        registration_payment_details_path(registration_reference: registration.reference)
      )
    end

    it "paginates 100 registrations to a page" do
      get registration_non_payments_path

      expect(assigns(:registrations).limit_value).to eq(100)
    end

    it "shows the menu item" do
      get registration_non_payments_path

      expect(response.body).to include("Registration non-payments")
    end

    context "when the user's role has no access" do
      let(:user) { create(:user, :customer_service_adviser) }

      it "redirects to the permission denied page" do
        get registration_non_payments_path

        expect(response).to redirect_to("/pages/permission")
      end

      it "hides the menu item" do
        get root_path

        expect(response.body).not_to include("Registration non-payments")
      end
    end
  end
end
