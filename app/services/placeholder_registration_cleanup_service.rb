# frozen_string_literal: true

class PlaceholderRegistrationCleanupService < WasteExemptionsEngine::BaseService
  LIMIT_DEFAULT = 100_000
  def run(limit: LIMIT_DEFAULT)
    placeholder_registrations_to_remove(limit).destroy_all
  end

  private

  def placeholder_registrations_to_remove(limit)
    WasteExemptionsEngine::Registration
      .where(placeholder: true, created_at: ...oldest_possible_date)
      .limit(limit)
  end

  def oldest_possible_date
    # We use the same age limit as the transient registration cleanup
    max = Rails.configuration.max_transient_registration_age_days.to_i
    max.days.ago.beginning_of_day
  end
end
