# frozen_string_literal: true

class RenewalReminderEmailServiceSwitcher
  def self.first_reminder_service
    if renewals_enabled?
      FirstRenewalReminderService
    else
      TemporaryFirstRenewalReminderService
    end
  end

  def self.second_reminder_service
    if renewals_enabled?
      SecondRenewalReminderService
    else
      TemporarySecondRenewalReminderService
    end
  end

  def self.first_reminder_email_service
    if renewals_enabled?
      FirstRenewalReminderEmailService
    else
      TemporaryFirstRenewalReminderEmailService
    end
  end

  def self.second_reminder_email_service
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
