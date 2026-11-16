# frozen_string_literal: true

# Sends the reform comms email again to a contact whose earlier one was not delivered, under its
# own label so the follow-up can be told apart from the original.
class FollowUpReformCommsEmailService < WasteExemptionsEngine::BaseService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  TEMPLATE_ID = OctoberReformCommsEmailService::TEMPLATE_ID
  TEMPLATE_LABEL = "Reform comms follow-up email - November 2026"
  # One email covers every registration sharing an address, so this identifies the send
  NOTIFY_REFERENCE = "reform-comms-follow-up"

  def run(email:, registrations:)
    @email = email

    client = WasteExemptionsEngine::NotifyClient.new(reference: NOTIFY_REFERENCE)
    notify_result = client.send_email(email_address: @email, template_id: TEMPLATE_ID)

    registrations.each { |registration| create_log(registration:, notify_response: notify_result) }

    notify_result
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "email",
      template_id: TEMPLATE_ID,
      template_label: TEMPLATE_LABEL,
      sent_to: @email
    }
  end
end
