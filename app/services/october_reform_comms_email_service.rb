# frozen_string_literal: true

require "notifications/client"

class OctoberReformCommsEmailService < WasteExemptionsEngine::BaseService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  TEMPLATE_ID = "41977e01-54f0-485d-a531-dd8c937eccb5"

  def run(email:, registrations:)
    @email = email

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)
    notify_result = client.send_email(email_address: @email, template_id: TEMPLATE_ID)

    registrations.each { |registration| create_log(registration:, notify_response: notify_result) }

    notify_result
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "email",
      template_id: TEMPLATE_ID,
      template_label: "Reform comms email - October 2026",
      sent_to: @email
    }
  end
end
