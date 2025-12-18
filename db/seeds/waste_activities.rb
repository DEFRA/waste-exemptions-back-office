# frozen_string_literal: true

def seed_waste_activities
  seeds = JSON.parse(Rails.root.join("db/seeds/waste_activities.json").read)

  # Clear existing waste_activity_id from exemptions
  WasteExemptionsEngine::Exemption.find_each { |exemption| exemption.update(waste_activity_id: nil) }

  waste_activities = seeds["waste_activities"]
  waste_activities.each do |waste_activity|
    activity = WasteExemptionsEngine::WasteActivity.find_or_initialize_by(name: waste_activity["name"])
    activity.name_gerund = waste_activity["name_gerund"]
    activity.category = waste_activity["category"].to_i
    activity.save! if activity.changed?

    waste_activity["exemptions"].each do |exemption|
      exemption = WasteExemptionsEngine::Exemption.find_by(code: exemption)
      exemption.presence&.update(waste_activity_id: activity.id)
    end
  end
end

seed_waste_activities if !Rails.env.production? || ENV["ALLOW_SEED"]
