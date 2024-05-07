# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateExemptionsService do
  describe "#run" do
    subject(:update_exemptions) { described_class.run(params) }

    let(:first_exemption) { create(:exemption) }
    let(:second_exemption) { create(:exemption) }
    let(:first_bucket) { create(:bucket) }
    let(:second_bucket) { create(:bucket) }
    let(:first_band) { create(:band) }
    let(:second_band) { create(:band) }

    let(:params) do
      {
        first_exemption.id.to_s => { "band_id" => first_band.id, "bucket_ids" => [first_bucket.id.to_s] },
        second_exemption.id.to_s => { "band_id" => second_band.id, "bucket_ids" => [second_bucket.id.to_s] }
      }
    end

    context "when the update is successful" do
      it "updates the exemptions and their bucket exemptions" do
        expect { update_exemptions }.to change(WasteExemptionsEngine::BucketExemption, :count).by(2)

        first_exemption.reload
        expect(first_exemption.band_id).to eq(first_band.id)
        expect(first_exemption.buckets).to contain_exactly(first_bucket)

        second_exemption.reload
        expect(second_exemption.band_id).to eq(second_band.id)
        expect(second_exemption.buckets).to contain_exactly(second_bucket)
      end

      it "returns true" do
        expect(update_exemptions).to be true
      end
    end

    context "when the update fails" do
      before do
        allow(WasteExemptionsEngine::Exemption).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        allow(Rails.logger).to receive(:error) # Setup Rails.logger as a spy
      end

      it "does not update any exemptions or bucket exemptions" do
        expect { update_exemptions }.not_to change(WasteExemptionsEngine::BucketExemption, :count)
      end

      it "logs the error" do
        update_exemptions
        expect(Rails.logger).to have_received(:error).with(/Error updating exemptions:/)
      end

      it "returns false" do
        expect(update_exemptions).to be false
      end
    end

    context "when removing bucket exemptions" do
      let(:params) do
        {
          first_exemption.id.to_s => { "band_id" => first_band.id, "bucket_ids" => [] }
        }
      end

      before do
        first_exemption.bucket_exemptions.create(bucket: first_bucket)
        first_exemption.bucket_exemptions.create(bucket: second_bucket)
      end

      it "destroys all associated bucket exemptions" do
        expect { update_exemptions }.to change { first_exemption.bucket_exemptions.count }.from(2).to(0)
      end
    end
  end
end
