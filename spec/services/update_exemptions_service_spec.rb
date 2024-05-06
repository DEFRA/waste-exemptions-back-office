# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UpdateExemptionsService do
  describe '#run' do
    let(:exemption1) { create(:exemption) }
    let(:exemption2) { create(:exemption) }
    let(:bucket1) { create(:bucket) }
    let(:bucket2) { create(:bucket) }
    let(:band1) { create(:band) }
    let(:band2) { create(:band) }

    let(:params) do
      {
        exemption1.id => { 'band_id' => band1.id, 'bucket_ids' => [bucket1.id.to_s] },
        exemption2.id => { 'band_id' => band2.id, 'bucket_ids' => [bucket2.id.to_s] }
      }
    end

    subject { described_class.run(params) }

    context 'when the update is successful' do
      it 'updates the exemptions and their bucket exemptions' do
        expect { subject }.to change { WasteExemptionsEngine::BucketExemption.count }.by(2)

        exemption1.reload
        expect(exemption1.band_id).to eq(band1.id)
        expect(exemption1.buckets).to contain_exactly(bucket1)

        exemption2.reload
        expect(exemption2.band_id).to eq(band2.id)
        expect(exemption2.buckets).to contain_exactly(bucket2)
      end

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'when the update fails' do
      before do
        allow(WasteExemptionsEngine::Exemption).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'does not update any exemptions or bucket exemptions' do
        expect { subject }.not_to change { WasteExemptionsEngine::BucketExemption.count }
      end

      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with(/Error updating exemptions:/)
        subject
      end

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'when removing bucket exemptions' do
      let(:params) do
        {
          exemption1.id => { 'band_id' => band1.id, 'bucket_ids' => [] }
        }
      end

      before do
        exemption1.bucket_exemptions.create(bucket: bucket1)
        exemption1.bucket_exemptions.create(bucket: bucket2)
      end

      it 'destroys all associated bucket exemptions' do
        expect { subject }.to change { exemption1.bucket_exemptions.count }.from(2).to(0)
      end
    end
  end
end
