# frozen_string_literal: true

require "notifications/client"

class DeregistrationEmailService < RenewalReminderEmailService
  attr_reader :registration, :recipient

  # Use same attributes as deregistration email CSV export.
  ATTRIBUTES = Reports::DeregistrationEmailBatchSerializer::ATTRIBUTES

  def run(registration:, recipient:)
    @registration = Reports::RegistrationDeregistrationEmailPresenter.new(registration)
    @recipient = recipient

    send!
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
    "9148895b-e239-4118-8ffd-dadd9b2cf462"
  end
end
