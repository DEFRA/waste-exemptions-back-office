# frozen_string_literal: true

require "rails_helper"

RSpec.describe ZeroCostBandService do
  subject(:service) { described_class.new }

  before do
    allow(Logger).to receive(:new).and_return(instance_double(Logger, info: nil, error: nil))
  end

  describe "#run" do
    context "when the zero cost band does not exist" do
      it "creates the zero compliance cost band" do
        expect { service.run }.to change(WasteExemptionsEngine::Band, :count).by(1)

        band = WasteExemptionsEngine::Band.find_by(sequence: 0)

        expect(band).to be_present
        expect(band.name).to eq("Zero compliance cost band")
        expect(band.sequence).to eq(0)
        expect(band.initial_compliance_charge.charge_amount).to eq(0)
        expect(band.additional_compliance_charge.charge_amount).to eq(0)
      end
    end

    context "when the zero cost band already exists" do
      before do
        create(:band,
               name: "Zero compliance cost band",
               sequence: 0,
               initial_compliance_charge: create(:charge, :initial_compliance_charge, charge_amount: 0),
               additional_compliance_charge: create(:charge, :additional_compliance_charge, charge_amount: 0))
      end

      it "does not create a duplicate band" do
        expect { service.run }.not_to change(WasteExemptionsEngine::Band, :count)
      end
    end
  end

  describe "#assign_exemption" do
    let!(:zero_cost_band) do
      create(:band,
             name: "Zero compliance cost band",
             sequence: 0,
             initial_compliance_charge: create(:charge, :initial_compliance_charge, charge_amount: 0),
             additional_compliance_charge: create(:charge, :additional_compliance_charge, charge_amount: 0))
    end

    let!(:band_three) do
      create(:band,
             name: "Band 3",
             sequence: 3,
             initial_compliance_charge: create(:charge, :initial_compliance_charge, charge_amount: 3000),
             additional_compliance_charge: create(:charge, :additional_compliance_charge, charge_amount: 3000))
    end

    let!(:t28_exemption) do
      create(:exemption, code: "T28", band: band_three)
    end

    it "assigns the exemption to the zero cost band" do
      expect { service.assign_exemption("T28") }
        .to change { t28_exemption.reload.band }.from(band_three).to(zero_cost_band)
    end

    it "returns true on success" do
      expect(service.assign_exemption("T28")).to be true
    end

    context "when zero cost band does not exist" do
      before { zero_cost_band.destroy }

      it "returns false" do
        expect(service.assign_exemption("T28")).to be false
      end
    end

    context "when exemption does not exist" do
      it "returns false" do
        expect(service.assign_exemption("INVALID")).to be false
      end
    end
  end
end
