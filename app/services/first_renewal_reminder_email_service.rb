# frozen_string_literal: true

require "notifications/client"

class FirstRenewalReminderEmailService < RenewalReminderEmailService

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "email",
      template_id: template,
      template_label: "First renewal reminder email",
      sent_to: @registration.contact_email
    }
  end

  private

  def template
    "1ef273a9-b5e5-4a48-a343-cf6c774b8211"
  end
end
