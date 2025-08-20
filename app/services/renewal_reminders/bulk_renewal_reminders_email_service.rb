# frozen_string_literal: true

module RenewalReminders

  attr_accessor :reminder_sequence

  class BulkRenewalRemindersEmailService < BulkRenewalRemindersServiceBase
    def run(reminder_sequence)
      @reminder_sequence = reminder_sequence

      expiring_registrations.each do |registration|
        send_email(registration)
      rescue StandardError => e
        Airbrake.notify e, registration: registration.reference
        Rails.logger.error "Failed to send first renewal email for registration #{registration.reference}"
      end
    end

    private

    def send_email(registration)
      case @reminder_sequence
      when :first
        RenewalReminderEmailServiceSelector.first_reminder_email_service(registration).run(registration:)
      when :second
        RenewalReminderEmailServiceSelector.second_reminder_email_service(registration).run(registration:)
      end
    end

    def expires_in_days
      case @reminder_sequence
      when :first
        WasteExemptionsEngine.configuration.renewal_window_before_expiry_in_days.to_i
      when :second
        WasteExemptionsBackOffice::Application.config.second_renewal_email_reminder_days.to_i
      end
    end

    def expiring_registrations
      default_scope.where(
        id: all_active_exemptions_registration_ids
      ).contact_email_present.site_address_is_not_nccc
    end
  end
end
