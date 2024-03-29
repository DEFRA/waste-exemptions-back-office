# frozen_string_literal: true

require "notifications/client"

class FinalRenewalReminderTextService < RenewalReminderTextService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(registration:)
    super(registration:)

    create_log(registration:)
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "text",
      template_id: template,
      template_label: "Final renewal reminder text",
      sent_to: @registration.contact_phone
    }
  end

  def template
    "7d101a7d-9678-464e-a57d-e18714afbc5d"
  end
end
