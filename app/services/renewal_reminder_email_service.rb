# frozen_string_literal: true

require "notifications/client"

class RenewalReminderEmailService < RenewalReminderService
  def run(registration:)
    @registration = registration

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

    client.send_email(email_address: @registration.contact_email,
                      template_id: template,
                      personalisation: personalisation)
  end
end
