# frozen_string_literal: true

class TemporarySecondRenewalReminderService < RenewalReminderServiceBase
  private

  def send_email(registration)
    TemporarySecondRenewalReminderEmailService.run(registration: registration)
  end

  def expires_in_days
    WasteExemptionsBackOffice::Application.config.second_renewal_email_reminder_days.to_i
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
