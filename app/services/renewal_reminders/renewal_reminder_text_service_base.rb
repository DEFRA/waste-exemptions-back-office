# frozen_string_literal: true

require "notifications/client"

module RenewalReminders

  class RenewalReminderTextServiceBase < RenewalReminderServiceBase
    include WasteExemptionsEngine::CanHaveCommunicationLog

    def run(registration:)
      return unless registration.valid_mobile_phone_number?

      @registration = registration

      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      client.send_sms(
        phone_number: @registration.contact_phone,
        template_id: template,
        personalisation: personalisation
      )

      create_log(registration:)
    end

    # For CanHaveCommunicationLog
    def communications_log_params
      {
        message_type: message_type,
        template_id: template,
        template_label: template_label,
        sent_to: @registration.send(sent_to_method)
      }
    end

    private

    def message_type
      "text"
    end

    def sent_to_method
      :contact_phone
    end
  end
end
