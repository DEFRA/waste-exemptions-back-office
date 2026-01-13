# frozen_string_literal: true

require "notifications/client"

module RenewalReminders

  class TemporarySecondRenewalReminderEmailService < RenewalReminderEmailServiceBase
    # For CanHaveCommunicationLog
    def communications_log_params
      {
        message_type: "email",
        template_id: template,
        template_label: "Temporary second renewal reminder email",
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
        Templates::RENEWAL_REMINDER_TEMPORARY
      end
    end

    # replace the magic link URL with the registration URL
    def personalisation
      super.merge(magic_link_url: registration_url)
    end

    # New method to provide the registration URL instead of renewal link
    def registration_url
      Rails.configuration.front_office_url +
        WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path
    end
  end
end
