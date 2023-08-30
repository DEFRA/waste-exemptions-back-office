# frozen_string_literal: true

require "notifications/client"

class DeregistrationEmailService < RenewalReminderEmailService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  attr_reader :registration, :recipient

  # Use same attributes as deregistration email CSV export.
  ATTRIBUTES = Reports::DeregistrationEmailBatchSerializer::ATTRIBUTES

  def run(registration:, recipient:)
    @registration = Reports::RegistrationDeregistrationEmailPresenter.new(registration)
    @recipient = recipient

    notify_result = send!

    create_log(registration:)

    notify_result
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "email",
      template_id: template,
      template_label: I18n.t("template_labels.deregistration_invitation_email"),
      sent_to: @registration.contact_email
    }
  end

  private

  def send!
    client.send_email(
      email_address: recipient,
      template_id: template,
      personalisation: personalisation
    )
  end

  def client
    @client ||= Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)
  end

  def personalisation
    [
      ATTRIBUTES,
      ATTRIBUTES.map { |attr| registration.public_send(attr) }
    ].transpose.to_h
  end

  def template
    "55faba44-2281-47e8-80a3-9ecb7556eb2e"
  end
end
