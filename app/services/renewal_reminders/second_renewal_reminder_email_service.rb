# frozen_string_literal: true

require "notifications/client"

module RenewalReminders

  class SecondRenewalReminderEmailService < RenewalReminderEmailServiceBase

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
      @registration.is_legacy_bulk ? "69a8254e-2bd0-4e09-b27a-ad7e8a29d783" : "f308a8a9-0358-41e1-b633-ea4044ad9580"
    end
  end
end
