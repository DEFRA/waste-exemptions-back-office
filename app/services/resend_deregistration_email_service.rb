# frozen_string_literal: true

class ResendDeregistrationEmailService < WasteExemptionsEngine::BaseService
  attr_reader :registration

  def run(registration:)
    @registration = registration
    de_reg_comm_label = I18n.t("template_labels.deregistration_invitation_email")

    WasteExemptionsEngine::Registration.transaction do
      if registration.received_comms?(de_reg_comm_label)
        de_reg_comm = registration.communication_logs.find { |c| c.template_label == de_reg_comm_label }
        de_reg_comm.destroy
      end

      SendDeregistrationEmailJob.perform_later(registration.id)
    end

    true
  rescue StandardError => e
    Airbrake.notify e, reference: registration.reference
    Rails.logger.error "Resend deregistration email for registration #{registration.id}:\n#{e}"

    false
  end
end
