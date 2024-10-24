# frozen_string_literal: true

def seed_charging_schemes
  seeds = JSON.parse(Rails.root.join("db/seeds/charging_schemes.json").read)

  # Bands
  bands = seeds["bands"]
  bands.each do |band_details|
    create_or_update_band(band_details)
  end

  charges = seeds["charges"]
  charges.each do |charge_details|
    create_or_update_charge(charge_details)
  end

  # Buckets
  buckets = seeds["buckets"]
  buckets.each do |bucket_details|
    create_or_update_bucket(bucket_details)
  end

  # Band Exemptions
  band_exemptions = seeds["band_exemptions"]
  band_exemptions.each { |details| update_band_exemptions(details) }

  # Bucket Exemptions
  bucket_exemptions = seeds["bucket_exemptions"]
  bucket_exemptions.each { |details| update_bucket_exemptions(details) }
end

def create_or_update_band(band_details)
  band = WasteExemptionsEngine::Band.find_or_initialize_by(sequence: band_details["sequence"])
  band.name = band_details["name"]
  band.save! if band.changed?

  # initial_compliance_charge
  create_or_update_nested_charge(band, :initial_compliance_charge, band_details["initial_compliance_charge"])

  # additional_compliance_charge
  create_or_update_nested_charge(band, :additional_compliance_charge, band_details["additional_compliance_charge"])
end

def create_or_update_charge(charge_details)
  # do not use this method for nested charges
  return unless ["registration_charge"].include?(charge_details["charge_type"])

  charge = WasteExemptionsEngine::Charge.find_or_initialize_by(charge_type: charge_details["charge_type"])
  charge.name = charge_details["name"]
  charge.charge_amount = charge_details["charge_amount"]
  charge.save! if charge.changed?
end

def create_or_update_nested_charge(entity, charge_type, charge_amount)
  entity_charge = entity.send(charge_type)

  # initial_compliance_charge
  if entity_charge.present?
    entity_charge.name = "#{charge_type.to_s.gsub('_', ' ')} for #{entity.name}"
    entity_charge.charge_amount = charge_amount
  else
    entity_charge = WasteExemptionsEngine::Charge.new(
      charge_type: charge_type,
      name: "#{charge_type.to_s.gsub('_', ' ')} for #{entity.name}",
      charge_amount: charge_amount,
      chargeable: entity
    )
  end
  entity_charge.save! if entity_charge.changed?
end

def create_or_update_bucket(bucket_details)
  bucket = WasteExemptionsEngine::Bucket.find_or_initialize_by(bucket_type: bucket_details["bucket_type"])
  bucket.name = bucket_details["name"]
  bucket.save! if bucket.changed?

  # initial_compliance_charge
  create_or_update_nested_charge(bucket, :initial_compliance_charge, bucket_details["initial_compliance_charge"])
end

def update_band_exemptions(band_exemption_details)
  band = WasteExemptionsEngine::Band.find_by(sequence: band_exemption_details["band_sequence"])
  return if band.blank?

  update_entity_exemptions(band, band_exemption_details["exemption_codes"])
end

def update_bucket_exemptions(bucket_exemption_details)
  bucket = WasteExemptionsEngine::Bucket.find_by(bucket_type: bucket_exemption_details["bucket_type"])
  return if bucket.blank?

  update_entity_exemptions(bucket, bucket_exemption_details["exemption_codes"])
end

def update_entity_exemptions(entity, exemption_codes)
  return if entity.blank? || exemption_codes.blank?

  entity.exemptions = []
  exemption_codes.each do |exemption_code|
    exemption = WasteExemptionsEngine::Exemption.find_by(code: exemption_code)
    next if exemption.blank?

    entity.exemptions << exemption
  end
end

seed_charging_schemes if !Rails.env.production? || ENV["ALLOW_SEED"]
