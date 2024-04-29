# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bands" do
  let(:user) { create(:user, :system) }

  describe "GET /bands" do
    let!(:band) { create(:band, sequence: 99, initial_compliance_charge: 19_901, additional_compliance_charge: 5101) }

    context "when a system user is signed in" do
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
    context "when a system user is signed in" do
      before do
        sign_in(user)
      end

      it "renders the new template" do
        get new_band_path

        expect(response).to render_template(:new)
      end
    end

    context "when user without permission is signed in" do
      let(:non_permitted_user) { create(:user, :developer) }

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
    let(:params) { { name: "test band", sequence: 99, initial_compliance_charge: 15_000, additional_compliance_charge: 5000 } }

    context "when a system user is signed in" do
      before do
        sign_in(user)
      end

      it "creates the band, redirects to the band list and assigns the correct whodunnit to the version", :versioning do
        post "/bands", params: { band: params }

        band = WasteExemptionsEngine::Band.last
        expect(band.reload.name).to eq(params[:name])
        expect(band.reload.sequence).to eq(params[:sequence])
        expect(band.reload.initial_compliance_charge).to eq(params[:initial_compliance_charge])
        expect(band.reload.additional_compliance_charge).to eq(params[:additional_compliance_charge])

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
      let(:non_permitted_user) { create(:user, :developer) }

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

    context "when a system user is signed in" do
      before do
        sign_in(user)
      end

      it "renders the edit template" do
        get edit_band_path(band)

        expect(response).to render_template(:edit)
      end
    end

    context "when user without permission is signed in" do
      let(:non_permitted_user) { create(:user, :developer) }

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

    let(:params) { { name: "test band", sequence: 99, initial_compliance_charge: 15_000, additional_compliance_charge: 5000 } }

    context "when a system user is signed in" do
      before do
        sign_in(user)
      end

      it "updates the band, redirects to the band list and assigns the correct whodunnit to the version", :versioning do
        patch "/bands/#{band.id}", params: { band: params }

        expect(band.reload.name).to eq(params[:name])
        expect(band.reload.sequence).to eq(params[:sequence])
        expect(band.reload.initial_compliance_charge).to eq(params[:initial_compliance_charge])
        expect(band.reload.additional_compliance_charge).to eq(params[:additional_compliance_charge])

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
      let(:non_permitted_user) { create(:user, :developer) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        patch "/bands/#{band.id}", params: { band: params }

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "GET /bands/edit_registration_fee" do
    context "when a system user is signed in" do
      before do
        sign_in(user)
      end

      context "when bands already present" do
        let!(:band) { create(:band) }

        it "renders the edit template" do
          expect(band.registration_fee).to be_present
          get edit_registration_fee_bands_path

          expect(response).to render_template(:edit_registration_fee)
        end
      end

      context "when no bands present" do
        it "redirects to the index page with error message" do
          get edit_registration_fee_bands_path

          expect(response).to redirect_to("/bands")
          expect(flash[:error]).to eq("Please create bands before setting the registration fee")
        end
      end
    end

    context "when user without permission is signed in" do
      let(:non_permitted_user) { create(:user, :developer) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        get edit_registration_fee_bands_path

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "PATCH /bands/update_registration_fee" do
    let!(:first_band) { create(:band, registration_fee: 100) }
    let!(:second_band) { create(:band, registration_fee: 100) }

    let(:params) { { registration_fee: 199 } }

    context "when a system user is signed in" do
      before do
        sign_in(user)
      end

      it "updates the registration_fee, redirects to the band list and assigns the correct whodunnit to the version", :versioning do
        patch "/bands/update_registration_fee", params: { band: params }

        expect(first_band.reload.registration_fee).to eq(params[:registration_fee])
        expect(second_band.reload.registration_fee).to eq(params[:registration_fee])

        expect(response).to redirect_to(bands_path)
        expect(first_band.reload.versions.last.whodunnit).to eq(user.id.to_s)
        expect(second_band.reload.versions.last.whodunnit).to eq(user.id.to_s)
      end

      context "when the params are invalid" do
        let(:params) { { registration_fee: "aaa" } }

        it "does not update the registration_fee and renders the edit_registration_fee template" do
          patch "/bands/update_registration_fee", params: { band: params }

          expect(first_band.reload.registration_fee).to eq(100)
          expect(second_band.reload.registration_fee).to eq(100)
          expect(response).to render_template(:edit_registration_fee)
        end
      end
    end

    context "when a non-permitted user is signed in" do
      let(:non_permitted_user) { create(:user, :developer) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        patch "/bands/update_registration_fee", params: { band: params }

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
