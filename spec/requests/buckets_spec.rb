# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Buckets" do
  let(:user) { create(:user, :system) }

  describe "GET /buckets/:id/edit" do
    let(:bucket) { create(:bucket, name: "test bucket", charge_amount: 10_000) }

    context "when a system user is signed in" do
      before do
        sign_in(user)
      end

      it "renders the edit template" do
        get edit_bucket_path(bucket)

        expect(response).to render_template(:edit)
      end
    end

    context "when user without permission is signed in" do
      let(:non_permitted_user) { create(:user, :developer) }

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
    let(:bucket) { create(:bucket, name: "test bucket", charge_amount: 10_000) }

    let(:params) { { name: "new bucket", charge_amount: 20_001 } }

    context "when a system user is signed in" do
      before do
        sign_in(user)
      end

      it "updates the bucket, redirects to the band & bucket dashboard and assigns the correct whodunnit to the version", :versioning do
        patch "/buckets/#{bucket.id}", params: { bucket: params }

        expect(bucket.reload.name).to eq(params[:name])
        expect(bucket.reload.charge_amount).to eq(params[:charge_amount])

        expect(response).to redirect_to(bands_path)
        expect(bucket.reload.versions.last.whodunnit).to eq(user.id.to_s)
      end

      context "when the params are invalid" do
        let(:params) { { charge_amount: "aaa" } }

        it "does not update the bucket and renders the edit template" do
          patch "/buckets/#{bucket.id}", params: { bucket: params }

          expect(bucket.reload.charge_amount).to eq(10_000)
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
        patch "/buckets/#{bucket.id}", params: { bucket: params }

        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
