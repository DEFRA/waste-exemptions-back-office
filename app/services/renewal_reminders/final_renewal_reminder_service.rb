# frozen_string_literal: true

module RenewalReminders

  class FinalRenewalReminderService < BulkRenewalRemindersTextService
    private

    def send_text(registration)
      FinalRenewalReminderTextService.run(registration: registration)
    end

    def expires_in_days
      WasteExemptionsBackOffice::Application.config.final_renewal_text_reminder_days.to_i
    end

    def default_scope
      super.where.not(id: recent_renewals_ids)
    end

    def recent_renewals_ids
      WasteExemptionsEngine::Registration
        .renewals
        .where(submitted_at: 1.month.ago..Time.zone.now)
        .pluck(:referring_registration_id)
    end
  end
end
