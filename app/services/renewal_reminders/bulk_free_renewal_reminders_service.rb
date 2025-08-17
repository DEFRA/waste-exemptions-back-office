# frozen_string_literal: true

module RenewalReminders

  class BulkFreeRenewalRemindersService < BulkRenewalRemindersEmailService
    private

    def send_email(registration)
      FreeRenewalReminderEmailService.run(registration: registration)
    end

    def expiring_registrations
      default_scope.where(
        id: all_active_exemptions_registration_ids
      ).eligible_for_free_renewal
                   .contact_email_present.site_address_is_not_nccc
    end

    def expires_in_days
      WasteExemptionsEngine.configuration.renewal_window_before_expiry_in_days.to_i
    end
  end
end
