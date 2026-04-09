# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderPresenter do
  subject(:presenter) { described_class.new(order) }

  let(:bucket_band) { create(:band) }
  let(:chargeable_band) { create(:band) }
  let(:no_charge_band) { create(:band) }
  let(:exemption_one) { create(:exemption, code: "EX001", band: bucket_band) }
  let(:exemption_two) { create(:exemption, code: "EX002", band: chargeable_band) }
  let(:exemption_three) { create(:exemption, code: "EX003", band: no_charge_band) }
  let(:exemptions) { [exemption_one, exemption_two, exemption_three] }
  let(:bucket) { build(:bucket, exemptions: [exemption_one]) }
  let(:charge_detail) do
    build(
      :charge_detail,
      band_charge_details: [
        build(
          :band_charge_detail,
          band: chargeable_band,
          initial_compliance_charge_amount: 2500,
          additional_compliance_charge_amount: 0
        ),
        build(
          :band_charge_detail,
          band: no_charge_band,
          initial_compliance_charge_amount: 0,
          additional_compliance_charge_amount: 0
        )
      ]
    )
  end
  let(:order) { build(:order, exemptions: exemptions, bucket: bucket, charge_detail: charge_detail) }

  describe "#exemption_codes" do
    it "returns sorted exemption codes as a comma-separated string" do
      expect(presenter.exemption_codes).to eq("EX001, EX002, EX003")
    end
  end

  describe "#exemption_codes_excluding_bucket" do
    it "returns sorted exemption codes excluding bucket exemptions" do
      expect(presenter.exemption_codes_excluding_bucket).to eq("EX002, EX003")
    end

    it "returns all exemption codes if bucket is nil" do
      allow(order).to receive(:bucket).and_return(nil)
      expect(presenter.exemption_codes_excluding_bucket).to eq("EX001, EX002, EX003")
    end
  end

  describe "#chargeable_exemption_codes_excluding_bucket" do
    it "returns the charged exemption codes excluding bucket exemptions" do
      expect(presenter.chargeable_exemption_codes_excluding_bucket).to eq("EX002")
    end
  end

  describe "#no_charge_exemption_codes_excluding_bucket" do
    it "returns the no-charge exemption codes excluding bucket exemptions" do
      expect(presenter.no_charge_exemption_codes_excluding_bucket).to eq("EX003")
    end
  end

  describe "#bucket_exemption_codes" do
    it "returns sorted bucket exemption codes as a comma-separated string" do
      expect(presenter.bucket_exemption_codes).to eq("EX001")
    end

    it "returns nil if bucket is blank" do
      allow(order).to receive(:bucket).and_return(nil)
      expect(presenter.bucket_exemption_codes).to be_nil
    end
  end

  describe "#charge_breakdown_row_count" do
    it "counts the visible rows in the payment details charge table" do
      expect(presenter.charge_breakdown_row_count).to eq(5)
    end
  end
end
