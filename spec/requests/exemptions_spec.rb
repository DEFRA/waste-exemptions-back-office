# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Exemptions Controller" do
  let(:user) { create(:user, :super_agent) }

  let!(:exemptions) { create_list(:exemption, 3) }
  let!(:bands) { create_list(:band, 2) }
  let!(:buckets) do
    [
      create(:bucket, bucket_type: "farmer"),
      create(:bucket, bucket_type: "charity")
    ]
  end

  before { sign_in(user) }

  describe "GET /exemptions" do
    it "responds to the GET request with a 200 status code and renders the appropriate template" do
      get exemptions_path

      expect(response).to have_http_status(:ok)
      expect(response).to render_template("exemptions/index")
      expect(assigns(:exemptions)).to match_array(exemptions)
      expect(assigns(:bands)).to match_array(bands)
      expect(assigns(:buckets)).to match_array(buckets)
    end
  end

  describe "PUT /exemptions" do
    context "when the update is successful" do
      let(:request_params) do
        {
          exemptions: {
            exemptions[0].id => { band_id: bands[0].id, bucket_ids: [buckets[0].id] },
            exemptions[1].id => { band_id: bands[1].id, bucket_ids: [buckets[0].id, buckets[1].id] },
            exemptions[2].id => { band_id: bands[0].id, bucket_ids: [] }
          }
        }
      end

      it "updates the exemptions and redirects to the exemptions index page with a success notice" do
        put exemptions_path, params: request_params

        expect(response).to redirect_to(exemptions_path)
        expect(flash[:message]).to eq("Exemptions updated successfully.")

        exemptions.each(&:reload)
        expect(exemptions[0].band_id).to eq(bands[0].id)
        expect(exemptions[0].buckets).to contain_exactly(buckets[0])
        expect(exemptions[1].band_id).to eq(bands[1].id)
        expect(exemptions[1].buckets).to contain_exactly(buckets[0], buckets[1])
        expect(exemptions[2].band_id).to eq(bands[0].id)
        expect(exemptions[2].buckets).to be_empty
      end
    end

    context "when the update fails" do
      before do
        allow(WasteExemptionsEngine::Exemption).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      let(:request_params) do
        {
          exemptions: {
            exemptions[0].id => { band_id: nil, bucket_ids: [buckets[0].id] }
          }
        }
      end

      it "does not update the exemptions and renders the index template with an error message" do
        expect do
          put exemptions_path, params: request_params
        end.not_to change { exemptions.map(&:reload).map(&:attributes) }

        expect(response).to render_template("exemptions/index")
        expect(flash.now[:error]).to eq("Failed to update exemptions.")
        expect(assigns(:exemptions)).to match_array(exemptions)
        expect(assigns(:bands)).to match_array(bands)
        expect(assigns(:buckets)).to match_array(buckets)
      end
    end
  end
end
