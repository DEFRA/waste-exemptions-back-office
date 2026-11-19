# frozen_string_literal: true

# Sends the reform comms email again to a contact whose earlier one was not delivered, under its
# own label so the follow-up can be told apart from the original.
class FollowUpReformCommsEmailService < ReformCommsEmailService
  TEMPLATE_ID = OctoberReformCommsEmailService::TEMPLATE_ID
  TEMPLATE_LABEL = "Reform comms follow-up email - November 2026"
  # One email covers every registration sharing an address, so this identifies the send
  NOTIFY_REFERENCE = "reform-comms-follow-up"

  private

  def notify_client
    WasteExemptionsEngine::NotifyClient.new(reference: NOTIFY_REFERENCE)
  end
end
