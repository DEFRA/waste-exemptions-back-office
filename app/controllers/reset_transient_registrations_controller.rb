# frozen_string_literal: true

class ResetTransientRegistrationsController < ApplicationController
  def new
    authorize! :reset_transient_registrations, registration

    reset_transient_registrations_form
  end

  def update
    authorize! :reset_transient_registrations, registration

    if reset_transient_registrations_form.submit
      successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      redirect_to registration_path(reference: registration.reference), status: successful_redirection
      flash.now[:message] = t("reset_transient_registrations.flash.successful_reset")
    else
      unsuccessful_redirection = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE
      redirect_to registration_path(reference: registration.reference), status: unsuccessful_redirection
      flash.now[:error] = t("reset_transient_registrations.flash.no_transient_registrations")
    end
  end

  protected

  def reset_transient_registrations_form
    @reset_transient_registrations_form ||= ResetTransientRegistrationsForm.new(registration)
  end

  def registration
    @registration ||= WasteExemptionsEngine::Registration.find_by(reference: params[:id])
  end
end
