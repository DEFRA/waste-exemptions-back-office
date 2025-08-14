# frozen_string_literal: true

module RenewalReminders

  class RenewalReminderServiceBase < WasteExemptionsEngine::BaseService
    def run
      expiring_registrations.each do |registration|
        send_email(registration)
      rescue StandardError => e
        Airbrake.notify e, registration: registration.reference
        Rails.logger.error "Failed to send first renewal email for registration #{registration.reference}"
      end
    end

    private

    def send_email
      raise(NotImplementedError)
    end

    def expiring_registrations
      default_scope.where(
        id: all_active_exemptions_registration_ids
      ).contact_email_present.site_address_is_not_nccc
    end

    def all_active_exemptions_registration_ids
      WasteExemptionsEngine::RegistrationExemption
        .all_active_exemptions
        .where(expires_on: expires_in_days.days.from_now.to_date)
        .pluck(:registration_id)
    end

    def default_scope
      WasteExemptionsEngine::Registration
    end

    def expires_in_days
      raise(NotImplementedError)
    end
  end
end
