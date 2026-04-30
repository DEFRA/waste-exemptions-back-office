# frozen_string_literal: true

def seed_admin_areas
  EaPublicFaceAreaDataLoadService.run
end

seed_admin_areas if !Rails.env.production? || ENV["ALLOW_SEED"]
