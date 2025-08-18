# frozen_string_literal: true

module RenewalReminders

  class BulkRenewalReminderEmailServiceSelector
    def self.first_reminder_service
      if renewals_enabled?
        BulkFirstRenewalRemindersEmailService
      else
        BulkTemporaryFirstRenewalRemindersEmailService
      end
    end

    def self.second_reminder_service
      if renewals_enabled?
        BulkSecondRenewalRemindersEmailService
      else
        BulkTemporarySecondRenewalRemindersEmailService
      end
    end

    def self.first_reminder_email_service
      if renewals_enabled?
        FirstRenewalReminderEmailService
      else
        TemporaryFirstRenewalReminderEmailService
      end
    end

    def self.renewals_enabled?
      WasteExemptionsEngine::FeatureToggle.active?(:enable_renewals)
    end
  end
end
