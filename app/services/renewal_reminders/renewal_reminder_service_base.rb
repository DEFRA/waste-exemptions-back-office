# frozen_string_literal: true

module RenewalReminders

  class RenewalReminderServiceBase < WasteExemptionsEngine::BaseService

    private

    def all_active_exemptions_registration_ids
      WasteExemptionsEngine::RegistrationExemption
        .all_active_exemptions
        .where(expires_on: expires_in_days.days.from_now.to_date)
        .pluck(:registration_id)
    end

    def default_scope
      WasteExemptionsEngine::Registration
    end

    def expires_in_days
      raise(NotImplementedError)
    end
  end
end
