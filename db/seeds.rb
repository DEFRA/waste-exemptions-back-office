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
  bands.each do |band|
    WasteExemptionsEngine::Band.find_or_create_by(name: band["name"]) do |rec|
      rec.sequence = band["sequence"]
      rec.registration_fee = band["registration_fee"]
      rec.initial_compliance_charge = band["initial_compliance_charge"]
      rec.additional_compliance_charge = band["additional_compliance_charge"]
    end
  end

  # Buckets
  buckets = seeds["buckets"]
  buckets.each do |bucket|
    WasteExemptionsEngine::Bucket.find_or_create_by(name: bucket["name"]) do |rec|
      rec.charge_amount = bucket["charge_amount"]
    end
  end
end

# Only seed if not running in production or we specifically require it, eg. for Heroku
seed_users if !Rails.env.production? || ENV["ALLOW_SEED"]
seed_charging_schemes if !Rails.env.production? || ENV["ALLOW_SEED"]
