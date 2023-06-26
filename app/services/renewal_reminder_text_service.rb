# frozen_string_literal: true

require "notifications/client"

class RenewalReminderTextService < RenewalReminderService
  def run(registration:)
    return unless registration.valid_mobile_phone_number?

    @registration = registration

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

    client.send_sms(phone_number: @registration.contact_phone,
                    template_id: template,
                    personalisation: personalisation)
  end
end
