# frozen_string_literal: true

class SendRegistrationConfirmationWhenBalanceFullyPaidJob < ApplicationJob
  queue_as :default

  REGISTRATION_COMPLETION_EMAIL_TEMPLATE_ID = "9025773f-35a3-4894-b8c6-105d65c19df4"

  def perform(reference:)
    registration = find_registration(reference)
    return unless registration
    return if registration.account.balance.negative?
    return if registration_confirmation_email_already_sent?(registration)

    send_registration_confirmation_email(registration)
  end

  private

  def find_registration(reference)
    WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def registration_confirmation_email_already_sent?(registration)
    registration.communication_logs.where(template_id: REGISTRATION_COMPLETION_EMAIL_TEMPLATE_ID).any?
  end

  def send_registration_confirmation_email(registration)
    recipient = registration.contact_email
    return if recipient.blank?

    WasteExemptionsEngine::ConfirmationEmailService.run(registration: registration, recipient: recipient)
  rescue StandardError => e
    Airbrake.notify(e, reference: registration.reference) if defined?(Airbrake)
    Rails.logger.error "Confirmation email error: #{e}"
  end
end
