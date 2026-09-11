# frozen_string_literal: true

class SendProofOfPaymentJob < ApplicationJob
  queue_as :default

  def perform(reference:)
    registration = WasteExemptionsEngine::Registration.find_by(reference:)
    return unless registration

    WasteExemptionsEngine::ProofOfPaymentService.run(registration:)
  rescue StandardError => e
    Airbrake.notify(e, reference:) if defined?(Airbrake)
    Rails.logger.error "Proof of payment error: #{e}"
  end
end
