# frozen_string_literal: true

class ReformCommsEmailService < WasteExemptionsEngine::BaseService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(email:, registrations:)
    @email = email
    @notify_reference = SecureRandom.uuid

    # Written before the send because the delivery receipt can arrive while they still are being
    registrations.each { |registration| create_log(registration:) }

    send_email
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "email",
      template_id: self.class::TEMPLATE_ID,
      template_label: self.class::TEMPLATE_LABEL,
      sent_to: @email,
      notification_id: @notify_reference
    }
  end

  private

  def send_email
    notify_result = notify_client.send_email(email_address: @email, template_id: self.class::TEMPLATE_ID)

    # rubocop:disable-next Rails/SkipsModelValidations
    logs.update_all(notify_response_params(notify_result)) if notify_result

    notify_result
  rescue StandardError
    discard_logs
    raise
  end

  # Otherwise the history claims an email was sent, and the address is skipped on a re-run
  def discard_logs
    WasteExemptionsEngine::RegistrationCommunicationLog.where(communication_log: logs).delete_all
    logs.delete_all
  end

  def logs
    WasteExemptionsEngine::CommunicationLog.where(notification_id: @notify_reference)
  end

  def notify_client
    WasteExemptionsEngine::NotifyClient.new(reference: @notify_reference)
  end
end
