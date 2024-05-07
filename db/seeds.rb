# frozen_string_literal: true

WasteExemptionsEngine::Engine.load_seed

def find_or_create_user(email, role)
  User.find_or_create_by(email: email) do |user|
    user.role = role
    user.password = ENV["DEFAULT_PASSWORD"] || "Secret123"
  end
end

def seed_users
  seeds = JSON.parse(Rails.root.join("db/seeds/users.json").read)
  users = seeds["users"]

  users.each do |user|
    find_or_create_user(user["email"], user["role"])
  end
end

def seed_charging_schemes
  seeds = JSON.parse(Rails.root.join("db/seeds/charging_schemes.json").read)

  # Bands
  bands = seeds["bands"]
  bands.each do |band_details|
    create_band_if_not_exists(band_details)
  end

  charges = seeds["charges"]
  charges.each do |charge_details|
    create_charge_if_not_exists(charge_details)
  end

  # Buckets
  buckets = seeds["buckets"]
  buckets.each do |bucket_details|
    create_bucket_if_not_exists(bucket_details)
  end
end

def create_band_if_not_exists(band_details)
  WasteExemptionsEngine::Band.find_or_create_by(name: band["name"]) do |rec|
    rec.sequence = band_details["sequence"]

    rec.initial_compliance_charge = WasteExemptionsEngine::Charge.find_or_create_by!(
      charge_type: "initial_compliance_charge", name: "initial compliance charge for #{band_details['name']}"
    ) do |charge|
      charge.charge_amount = band_details["initial_compliance_charge"]
    end

    rec.additional_compliance_charge = WasteExemptionsEngine::Charge.find_or_create_by(
      charge_type: "additional_compliance_charge", name: "additional compliance charge for #{band_details['name']}"
    ) do |charge|
      charge.charge_amount = band_details["additional_compliance_charge"]
    end
  end
end

def create_charge_if_not_exists(charge_details)
  WasteExemptionsEngine::Charge.find_or_create_by(
    charge_type: charge_details["charge_type"], name: charge_details["name"]
  ) do |rec|
    rec.charge_type = charge_details["charge_type"]
    rec.charge_amount = charge_details["charge_amount"]
  end
end

def create_bucket_if_not_exists(bucket_details)
  WasteExemptionsEngine::Bucket.find_or_create_by(name: bucket_details["name"]) do |rec|
    rec.initial_compliance_charge = WasteExemptionsEngine::Charge.find_or_create_by!(
      charge_type: "initial_compliance_charge", name: "initial compliance charge for #{bucket_details['name']}"
    ) do |charge|
      charge.charge_amount = bucket_details["initial_compliance_charge"]
    end
  end
end

# Only seed if not running in production or we specifically require it, eg. for Heroku
seed_users if !Rails.env.production? || ENV["ALLOW_SEED"]
seed_charging_schemes if !Rails.env.production? || ENV["ALLOW_SEED"]
