# frozen_string_literal: true

require "notifications/client"

class RenewalReminderEmailService < RenewalReminderService
  # So we can use displayable_address()
  include WasteExemptionsEngine::ApplicationHelper
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(registration:)
    @registration = registration

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

    notify_result = client.send_email(email_address: @registration.contact_email,
                                      template_id: template,
                                      personalisation: personalisation)

    create_log(registration:)

    notify_result
  end
end
