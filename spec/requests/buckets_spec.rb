# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Buckets" do
  let(:user) { create(:user, :developer) }

  describe "GET /buckets/:id/edit" do
    let(:bucket) { create(:bucket, name: "test bucket") }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "renders the edit template" do
        get edit_bucket_path(bucket)

        expect(response).to render_template(:edit)
      end
    end

    context "when user without permission is signed in" do
      let(:non_permitted_user) { create(:user, :data_agent) }

      before do
        sign_in(non_permitted_user)
      end

      it "redirects to the permissions error page" do
        get edit_bucket_path(bucket)

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "PATCH /buckets/:id" do
    let(:bucket) { create(:bucket, name: "test bucket") }

    let(:params) { { name: "new bucket", initial_compliance_charge_attributes: { charge_amount_in_pounds: 50.01 } } }

    context "when a permitted user is signed in" do
      before do
        sign_in(user)
      end

      it "updates the bucket, redirects to the band & bucket dashboard and assigns the correct whodunnit to the version", :versioning do
        patch "/buckets/#{bucket.id}", params: { bucket: params }

        expect(bucket.reload.name).to eq(params[:name])
        expect(bucket.reload.initial_compliance_charge.charge_amount_in_pounds.to_f).to eq(params[:initial_compliance_charge_attributes][:charge_amount_in_pounds])

        expect(response).to redirect_to(bands_path)
        expect(bucket.reload.versions.last.whodunnit).to eq(user.id.to_s)
      end

      context "when the params are invalid" do
        let(:params) { { initial_compliance_charge_attributes: { charge_amount_in_pounds: "aaa" } } }

        it "does not update the bucket and renders the edit template" do
          bucket_charge_amount = bucket.initial_compliance_charge.charge_amount
          patch "/buckets/#{bucket.id}", params: { bucket: params }

          expect(bucket.reload.initial_compliance_charge.charge_amount).to eq(bucket_charge_amount)
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
        patch "/buckets/#{bucket.id}", params: { bucket: params }

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
