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
      "5a4f6146-1952-4e62-9824-ab5d0bd9a978" # Template ID for temporary renewal reminders
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
