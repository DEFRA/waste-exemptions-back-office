# frozen_string_literal: true

class RenewalServiceSwitcher
  def self.first_reminder_service
    if use_temporary_services?
      TemporaryFirstRenewalReminderService
    else
      FirstRenewalReminderService
    end
  end

  def self.second_reminder_service
    if use_temporary_services?
      TemporarySecondRenewalReminderService
    else
      SecondRenewalReminderService
    end
  end

  def self.first_reminder_email_service
    if use_temporary_services?
      TemporaryFirstRenewalReminderEmailService
    else
      FirstRenewalReminderEmailService
    end
  end

  def self.second_reminder_email_service
    if use_temporary_services?
      TemporarySecondRenewalReminderEmailService
    else
      SecondRenewalReminderEmailService
    end
  end

  def self.use_temporary_services?
    WasteExemptionsEngine::FeatureToggle.active?(:use_temporary_renewal_services)
  end
end
