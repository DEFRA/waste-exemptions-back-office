# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "charge_detail")

module WasteExemptionsEngine
  class ChargeDetail
    def total_compliance_charge_amount
      band_charge_details.sum do |band|
        band.initial_compliance_charge_amount + band.additional_compliance_charge_amount
      end
    end
  end
end
