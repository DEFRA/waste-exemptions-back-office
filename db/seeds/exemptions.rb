# frozen_string_literal: true

def assign_category(record, category)
  record.category = category.strip.parameterize.underscore.to_sym
end

def seed_exemptions
  file = Rails.root.join("db/seeds/exemptions.csv").read
  csv = CSV.parse(file, headers: true)

  csv.each do |row|
    e = WasteExemptionsEngine::Exemption.find_or_initialize_by(code: row["code"].strip)
    assign_category(e, row["category"])
    e.url = row["url"].strip
    e.summary = row["summary"].strip
    e.description = row["description"].strip
    e.guidance = row["guidance-desc"].strip
    e.save! if e.changed?
  end
end

seed_exemptions if !Rails.env.production? || ENV["ALLOW_SEED"]
