# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bands" do
  let(:user) { create(:user, :developer) }

  describe "GET /bands" do
    let(:band) { create(:band, :no_charges, sequence: 99) }
    let(:initial_compliance_charge) { create(:charge, :initial_compliance_charge, charge_amount: 19_901, chargeable: band) }
    let(:additional_compliance_charge) { create(:charge, :additional_compliance_charge, charge_amount: 51_01, chargeable: band) }

    before do
      initial_compliance_charge
      additional_compliance_charge
    end

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "renders the index template" do
        get bands_path

        expect(response).to render_template(:index)
      end

      it "contains the bands" do
        get bands_path

        expect(response.body).to include(band.sequence.to_s)
        expect(response.body).to include("199.01")
        expect(response.body).to include("51.01")
      end
    end
  end

  describe "GET /bands/new" do
    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "renders the new template" do
        get new_band_path

        expect(response).to render_template(:new)
      end
    end

    context "when user without permission is signed in" do
      let(:non_permitted_user) { create(:user, :data_viewer) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        get new_band_path

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "POST /bands" do
    let(:params) { { name: "test band", sequence: 99, initial_compliance_charge_attributes: { charge_amount_in_pounds: 150.00 }, additional_compliance_charge_attributes: { charge_amount_in_pounds: 50.00 } } }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "creates the band, redirects to the band list and assigns the correct whodunnit to the version", :versioning do
        post "/bands", params: { band: params }

        band = WasteExemptionsEngine::Band.last
        expect(band.reload.name).to eq(params[:name])
        expect(band.reload.sequence).to eq(params[:sequence])
        expect(band.reload.initial_compliance_charge.charge_amount_in_pounds.to_f).to eq(params[:initial_compliance_charge_attributes][:charge_amount_in_pounds])
        expect(band.reload.additional_compliance_charge.charge_amount_in_pounds.to_f).to eq(params[:additional_compliance_charge_attributes][:charge_amount_in_pounds])

        expect(response).to redirect_to(bands_path)
        expect(band.reload.versions.last.whodunnit).to eq(user.id.to_s)
      end

      context "when the params are invalid" do
        let(:params) { { sequence: "aaa" } }

        it "does not update the band and renders the new template" do
          post "/bands", params: { band: params }

          expect(WasteExemptionsEngine::Band.count).to eq(0)
          expect(response).to render_template(:new)
        end
      end
    end

    context "when a non-permitted user is signed in" do
      let(:non_permitted_user) { create(:user, :data_viewer) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        post "/bands", params: { band: params }

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "GET /bands/:id/edit" do
    let(:band) { create(:band, sequence: 1) }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "renders the edit template" do
        get edit_band_path(band)

        expect(response).to render_template(:edit)
      end
    end

    context "when user without permission is signed in" do
      let(:non_permitted_user) { create(:user, :data_viewer) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        get edit_band_path(band)

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "PATCH /bands/:id" do
    let(:band) { create(:band, sequence: 1) }

    let(:params) { { name: "test band", sequence: 99, initial_compliance_charge_attributes: { charge_amount_in_pounds: 150.00 }, additional_compliance_charge_attributes: { charge_amount_in_pounds: 50.00 } } }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "updates the band, redirects to the band list and assigns the correct whodunnit to the version", :versioning do
        patch "/bands/#{band.id}", params: { band: params }

        expect(band.reload.name).to eq(params[:name])
        expect(band.reload.sequence).to eq(params[:sequence])
        expect(band.reload.initial_compliance_charge.charge_amount_in_pounds.to_f).to eq(params[:initial_compliance_charge_attributes][:charge_amount_in_pounds])
        expect(band.reload.additional_compliance_charge.charge_amount_in_pounds.to_f).to eq(params[:additional_compliance_charge_attributes][:charge_amount_in_pounds])

        expect(response).to redirect_to(bands_path)
        expect(band.reload.versions.last.whodunnit).to eq(user.id.to_s)
      end

      context "when the params are invalid" do
        let(:params) { { sequence: "aaa" } }

        it "does not update the band and renders the edit template" do
          patch "/bands/#{band.id}", params: { band: params }

          expect(band.reload.sequence).to eq(1)
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when a non-permitted user is signed in" do
      let(:non_permitted_user) { create(:user, :data_viewer) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        patch "/bands/#{band.id}", params: { band: params }

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "GET /bands/:id/destroy_confirmation" do
    let(:band) { create(:band) }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
        get destroy_confirmation_band_path(band)
      end

      it "renders the destroy confirmation template" do
        expect(response).to render_template(:destroy_confirmation)
      end
    end
  end

  describe "DELETE /bands/:id" do
    let(:band) { create(:band) }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      context "when the band has exemptions" do
        before do
          create(:exemption, band: band)
        end

        it "redirects to the cannot destroy page" do
          delete "/bands/#{band.id}"

          expect(WasteExemptionsEngine::Band.count).to eq(1)
          expect(response).to redirect_to(cannot_destroy_band_path(band))
        end
      end

      context "when the band has no exemptions" do
        it "deletes the band and redirects to the band list" do
          delete "/bands/#{band.id}"

          expect(WasteExemptionsEngine::Band.count).to eq(0)
          expect(response).to redirect_to(bands_path)
        end

        it "fails to delete the band and renders the index template" do
          allow(WasteExemptionsEngine::Band).to receive(:find).and_return(band)
          allow(band).to receive_messages(can_be_destroyed?: true, destroy: false)

          delete "/bands/#{band.id}"

          expect(WasteExemptionsEngine::Band.count).to eq(1)
          expect(flash[:error]).to eq "There was an error removing the band"
          expect(response).to redirect_to(bands_path)
        end
      end
    end

    context "when a non-permitted user is signed in" do
      let(:non_permitted_user) { create(:user, :data_viewer) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        delete "/bands/#{band.id}"

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
