# frozen_string_literal: true

class RenewalReminderTextServiceBase < RenewalReminderServiceBase
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
    ).applicant_phone_present.site_address_is_not_nccc
  end
end
