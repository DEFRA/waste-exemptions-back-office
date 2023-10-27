# frozen_string_literal: true

class ResetTransientRegistrationsController < ApplicationController
  def new
    Rails.logger.info "THE CURRENT ROLE IS: #{current_user.role}"
    authorize! :reset_transient_registrations, registration

    reset_transient_registrations_form
  end

  def update
    authorize! :reset_transient_registrations, registration

    if reset_transient_registrations_form.submit
      successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      redirect_to registration_path(reference: registration.reference), status: successful_redirection
    else
      render :new
      false
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
