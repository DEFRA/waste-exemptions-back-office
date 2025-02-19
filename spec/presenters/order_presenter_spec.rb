# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderPresenter do
  subject(:presenter) { described_class.new(order) }

  let(:exemption_one) { build(:exemption, code: "EX001") }
  let(:exemption_two) { build(:exemption, code: "EX002") }
  let(:exemption_three) { build(:exemption, code: "EX003") }
  let(:exemptions) { [exemption_one, exemption_two, exemption_three] }
  let(:bucket) { build(:bucket, exemptions: [exemption_one, exemption_two]) }
  let(:order) { build(:order, exemptions: exemptions, bucket: bucket) }

  describe "#exemption_codes" do
    it "returns sorted exemption codes as a comma-separated string" do
      expect(presenter.exemption_codes).to eq("EX001, EX002, EX003")
    end
  end

  describe "#exemption_codes_excluding_bucket" do
    it "returns sorted exemption codes excluding bucket exemptions as a comma-separated string" do
      expect(presenter.exemption_codes_excluding_bucket).to eq("EX003")
    end

    it "returns all exemption codes if bucket is nil" do
      allow(order).to receive(:bucket).and_return(nil)
      expect(presenter.exemption_codes_excluding_bucket).to eq("EX001, EX002, EX003")
    end
  end

  describe "#bucket_exemption_codes" do
    it "returns sorted bucket exemption codes as a comma-separated string" do
      expect(presenter.bucket_exemption_codes).to eq("EX001, EX002")
    end

    it "returns nil if bucket is blank" do
      allow(order).to receive(:bucket).and_return(nil)
      expect(presenter.bucket_exemption_codes).to be_nil
    end
  end
end
