# frozen_string_literal: true

module RenewalReminders

  class RenewalReminderTextServiceBase < RenewalReminderEmailServiceBase
    def run
      expiring_registrations.each do |registration|
        send_text(registration) if registration.valid_mobile_phone_number?
      rescue StandardError => e
        Airbrake.notify e, registration: registration.reference
        Rails.logger.error "Failed to send renewal reminder text for registration #{registration.reference}"
      end
    end

    private

    def send_text
      raise(NotImplementedError)
    end

    def expiring_registrations
      default_scope.where(
        id: all_active_exemptions_registration_ids
      ).contact_phone_present.site_address_is_not_nccc
    end
  end
end
