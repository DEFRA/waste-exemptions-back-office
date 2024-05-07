# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Charges" do
  let(:user) { create(:user, :developer) }

  describe "GET /charges/:id/edit" do
    let(:charge) { create(:charge, :registration_charge) }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "renders the edit template" do
        get edit_charge_path(charge)

        expect(response).to render_template(:edit)
      end
    end

    context "when user without permission is signed in" do
      let(:non_permitted_user) { create(:user, :data_agent) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        get edit_charge_path(charge)

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "PATCH /charges/:id" do
    let(:charge) { create(:charge, :registration_charge, charge_amount: 100) }

    let(:params) { { charge_amount_in_pounds: 150.00 } }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "updates the charge, redirects to the bands & charges page and assigns the correct whodunnit to the version", :versioning do
        patch "/charges/#{charge.id}", params: { charge: params }

        expect(charge.reload.charge_amount_in_pounds.to_f).to eq(params[:charge_amount_in_pounds])

        expect(response).to redirect_to(bands_path)
        expect(charge.reload.versions.last.whodunnit).to eq(user.id.to_s)
      end

      context "when the params are invalid" do
        let(:params) { { charge_amount_in_pounds: "aaa" } }

        it "does not update the charge and renders the edit template" do
          patch "/charges/#{charge.id}", params: { charge: params }

          expect(charge.reload.charge_amount).to eq(100)
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when a non-permitted user is signed in" do
      let(:non_permitted_user) { create(:user, :data_agent) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        patch "/charges/#{charge.id}", params: { charge: params }

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
