# frozen_string_literal: true

require "notifications/client"

class RenewalReminderTextService < RenewalReminderService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(registration:)
    return unless registration.valid_mobile_phone_number?

    @registration = registration

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

    notify_result = client.send_sms(
      phone_number: @registration.contact_phone,
      template_id: template,
      personalisation: personalisation
    )

    create_log(registration)

    notify_result
  end
end
