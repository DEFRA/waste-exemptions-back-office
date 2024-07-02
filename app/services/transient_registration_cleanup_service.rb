# frozen_string_literal: true

class TransientRegistrationCleanupService < WasteExemptionsEngine::BaseService
  LIMIT_DEFAULT = 100_000
  def run(limit: LIMIT_DEFAULT)
    transient_registrations_to_remove(limit).destroy_all
  end

  private

  def transient_registrations_to_remove(limit)
    WasteExemptionsEngine::TransientRegistration.where(created_at: ...oldest_possible_date).limit(limit)
  end

  def oldest_possible_date
    max = Rails.configuration.max_transient_registration_age_days.to_i
    max.days.ago.beginning_of_day
  end
end
