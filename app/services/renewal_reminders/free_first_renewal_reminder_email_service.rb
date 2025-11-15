# frozen_string_literal: true

require "notifications/client"

module RenewalReminders

  class FreeFirstRenewalReminderEmailService < RenewalReminderEmailServiceBase

    # For CanHaveCommunicationLog
    def communications_log_params
      {
        message_type: "email",
        template_id: template,
        template_label: "First non-chargeable renewal reminder email",
        sent_to: @registration.contact_email
      }
    end

    private

    def template
      return "b1c9cda2-b502-4667-b22c-63e8725f7a27" unless @registration.legacy_bulk_or_multisite?

      renewals_enabled? ? "cda801d8-ad08-4e77-ab46-94b0e9689ed7" : "69a8254e-2bd0-4e09-b27a-ad7e8a29d783"
    end
  end
end
