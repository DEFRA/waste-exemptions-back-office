# frozen_string_literal: true

class ReformCommsEmailService < WasteExemptionsEngine::BaseService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(email:, registrations:)
    @email = email

    notify_result = notify_client.send_email(email_address: @email, template_id: self.class::TEMPLATE_ID)

    registrations.each { |registration| create_log(registration:, notify_response: notify_result) }

    notify_result
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "email",
      template_id: self.class::TEMPLATE_ID,
      template_label: self.class::TEMPLATE_LABEL,
      sent_to: @email
    }
  end

  private

  # The client to send through, which decides what accompanies the message
  def notify_client
    raise NotImplementedError
  end
end
