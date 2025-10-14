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

# Only seed if not running in production or we specifically require it, eg. for Heroku
if !Rails.env.production? || ENV["ALLOW_SEED"]
  seed_users

  # Load additional seed files from db/seeds/ directory
  load 'db/seeds/exemptions.rb'
  load 'db/seeds/waste_activities.rb'
  load 'db/seeds/charging_schemes.rb'
end
