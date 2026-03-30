# frozen_string_literal: true

class ResendConfirmationEmailController < ApplicationController
  include CanSetFlashMessages

  def new
    authorize

    begin
      send_emails

      flash_success(success_message)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reference
      Rails.logger.error "Failed to send confirmation email for registration #{registration.reference}"

      flash_error(failure_message, failure_description)
    end

    redirect_back_or_to(root_path)
  end

  private

  def registration
    @_registration ||= WasteExemptionsEngine::Registration
                       .includes(registration_exemptions: :exemption)
                       .find_by(reference: params[:reference])
  end

  def authorize
    authorize! :send_comms, WasteExemptionsEngine::Registration
  end

  def send_emails
    return if registration.contact_email.blank?

    WasteExemptionsEngine::ConfirmationEmailService.run(registration: registration,
                                                        recipient: registration.contact_email)
  end

  def success_message
    if registration.contact_email.present?
      I18n.t("resend_confirmation_email.messages.success",
             contact_email: registration.contact_email)
    else
      I18n.t("resend_confirmation_email.messages.no_recipient")
    end
  end

  def failure_message
    I18n.t("resend_confirmation_email.messages.failure",
           contact_email: registration.contact_email)
  end

  def failure_description
    I18n.t("resend_confirmation_email.messages.failure_details")
  end
end
