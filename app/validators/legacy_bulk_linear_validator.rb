# frozen_string_literal: true

# A registration cannot be mnarked as both legacy multisite and legacy linear.
class LegacyBulkLinearValidator < WasteExemptionsEngine::BaseValidator

  def validate(record)
    legacy_bulk = record.is_legacy_bulk
    legacy_linear = record.is_linear

    record.errors.add(:base, "is_legacy_bulk and is_linear cannot both be true") if legacy_bulk && legacy_linear
  end
end
