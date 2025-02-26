# frozen_string_literal: true

require "notifications/client"

class RenewalReminderEmailService < RenewalReminderService
  # So we can use displayable_address()
  include WasteExemptionsEngine::ApplicationHelper
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(registration:, skip_opted_out_check: false)
    if registration.reminder_opt_in? || skip_opted_out_check
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
      template_id: nil,
      template_label: "User is opted out - No renewal reminder email sent",
      sent_to: registration.contact_email
    )
  end

  private

  def message_type
    "email"
  end

  def sent_to_method
    :contact_email
  end
end
