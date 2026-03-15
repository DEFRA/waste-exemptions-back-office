# frozen_string_literal: true

module RenewalReminders

  class RenewalReminderEmailServiceSelector
    def self.first_reminder_email_service(registration)
      return FirstRenewalReminderEmailService if registration.is_legacy_bulk

      if renewals_enabled?
        FirstRenewalReminderEmailService
      else
        TemporaryFirstRenewalReminderEmailService
      end
    end

    def self.second_reminder_email_service(registration)
      return SecondRenewalReminderEmailService if registration.is_legacy_bulk

      if renewals_enabled?
        SecondRenewalReminderEmailService
      else
        TemporarySecondRenewalReminderEmailService
      end
    end

    def self.renewals_enabled?
      WasteExemptionsEngine::FeatureToggle.active?(:enable_renewals)
    end
  end
end
