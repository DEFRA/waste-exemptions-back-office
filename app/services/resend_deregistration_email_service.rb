# frozen_string_literal: true

class ResendDeregistrationEmailService < WasteExemptionsEngine::BaseService
  attr_reader :registration

  def run(registration:)
    @registration = registration

    WasteExemptionsEngine::Registration.transaction do
      registration.update!(deregistration_email_sent_at: nil)
      SendDeregistrationEmailJob.perform_later(registration.id)
    end

    true
  rescue StandardError => e
    Airbrake.notify e, reference: registration.reference
    Rails.logger.error "Resend deregistration email for registration #{registration.id}:\n#{e}"

    false
  end
end
