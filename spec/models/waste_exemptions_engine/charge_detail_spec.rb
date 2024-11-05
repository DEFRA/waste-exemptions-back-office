# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::ChargeDetail do

  describe "#total_compliance_charge_amount" do
    subject(:charge_amount) { described_class.new(band_charge_details:).total_compliance_charge_amount }

    context "with no band charges" do
      let(:band_charge_details) { [] }

      it { expect(charge_amount).to be_zero }
    end

    context "with band charges" do
      let(:band_charge_details) do
        [
          build(:band_charge_detail, initial_compliance_charge_amount: 5, additional_compliance_charge_amount: 10),
          build(:band_charge_detail, initial_compliance_charge_amount: 15, additional_compliance_charge_amount: 0),
          build(:band_charge_detail, initial_compliance_charge_amount: 22, additional_compliance_charge_amount: 11)
        ]
      end

      it { expect(charge_amount).to eq(63) }
    end
  end
end
