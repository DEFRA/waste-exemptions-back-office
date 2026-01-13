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
      if @registration.linear?
        Templates::RENEWAL_REMINDER_LINEAR
      elsif @registration.is_legacy_bulk?
        Templates::RENEWAL_REMINDER_LEGACY_BULK
      else
        Templates::SECOND_RENEWAL_REMINDER
      end
    end
  end
end
