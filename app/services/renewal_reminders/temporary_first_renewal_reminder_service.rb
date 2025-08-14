# frozen_string_literal: true

module RenewalReminders

  class TemporaryFirstRenewalReminderService < RenewalReminderEmailServiceBase
    private

    def send_email(registration)
      TemporaryFirstRenewalReminderEmailService.run(registration: registration)
    end

    def expires_in_days
      WasteExemptionsEngine.configuration.renewal_window_before_expiry_in_days.to_i
    end
  end
end
