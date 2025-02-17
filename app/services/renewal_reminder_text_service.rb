# frozen_string_literal: true

require "notifications/client"

class RenewalReminderTextService < RenewalReminderService

  def run(registration:)
    return unless registration.valid_mobile_phone_number?

    if WasteExemptionsEngine::BetaParticipant.exists?(reg_number: registration.reference)
      create_beta_participant_log(registration:)
      return
    end

    @registration = registration

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

    client.send_sms(
      phone_number: @registration.contact_phone,
      template_id: template,
      personalisation: personalisation
    )
  end

  def create_beta_participant_log(registration:)
    registration.communication_logs.create(
      message_type: "text",
      template_id: template,
      template_label: "beta_participant",
      sent_to: registration.contact_phone
    )
  end
end
