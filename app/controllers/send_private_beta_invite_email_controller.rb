# frozen_string_literal: true

class SendPrivateBetaInviteEmailController < ApplicationController
  include CanSetFlashMessages

  def new
    authorize

    begin
      send_emails

      flash_success(success_message)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reference
      Rails.logger.error "Failed to send private beta invite email for registration #{registration.reference}"

      flash_error(failure_message, failure_description)
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def registration
    @_registration ||= WasteExemptionsEngine::Registration.find_by(reference: params[:reference])
  end

  def authorize
    authorize! :invite_private_beta, WasteExemptionsEngine::Registration
  end

  def send_emails
    beta_participant = WasteExemptionsEngine::BetaParticipant.find_by(reg_number: registration.reference)
    if beta_participant.nil?
      beta_participant = WasteExemptionsEngine::BetaParticipant.create(reg_number: registration.reference,
                                                                       email: recipient_email)
    end
    PrivateBetaInviteEmailService.run(registration: registration, beta_participant: beta_participant)
  end

  def recipient_email
    registration.contact_email
  end

  def success_message
    I18n.t("send_private_beta_invite_email.messages.success", email: recipient_email)
  end

  def failure_message
    I18n.t("send_private_beta_invite_email.messages.failure", email: recipient_email)
  end

  def failure_description
    I18n.t("send_private_beta_invite_email.messages.failure_details")
  end
end
