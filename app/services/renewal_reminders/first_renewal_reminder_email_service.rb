# frozen_string_literal: true

require "notifications/client"

module RenewalReminders

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
      "b1c9cda2-b502-4667-b22c-63e8725f7a27"
    end
  end
end
