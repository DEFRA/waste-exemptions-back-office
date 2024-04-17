# frozen_string_literal: true

require "notifications/client"

class RenewalReminderEmailService < RenewalReminderService
  # So we can use displayable_address()
  include WasteExemptionsEngine::ApplicationHelper
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(registration:)
    if registration.reminder_opt_in?
      @registration = registration
      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      notify_result = client.send_email(email_address: @registration.contact_email,
                                        template_id: template,
                                        personalisation: personalisation)

      create_log(registration:)

      notify_result
    else
      create_opted_out_log(registration:)
    end
  end

  def create_opted_out_log(registration:)
    registration.communication_logs.create(
      message_type: "email",
      template_id: "N/A",
      template_label: "USER OPTED OUT - NO RENEWAL REMINDER EMAIL SENT",
      sent_to: registration.contact_email
    )
  end
end
