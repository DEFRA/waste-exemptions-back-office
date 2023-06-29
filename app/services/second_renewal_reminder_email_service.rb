# frozen_string_literal: true

require "notifications/client"

class SecondRenewalReminderEmailService < RenewalReminderEmailService

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "email",
      template_id: template,
      template_label: "Second renewal reminder email",
      sent_to: @registration.contact_email
    }
  end

  private

  def template
    "80585fc6-9c65-4909-8cb4-6888fa4427c8"
  end
end
