# frozen_string_literal: true

class ModifyExpiryDateController < ApplicationController
  include WasteExemptionsEngine::EditPermissionChecks

  def new
    modify_expiry_date_form
  end

  def update
    if modify_expiry_date_form.submit(params[:modify_expiry_date_form])
      successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      redirect_to registration_path(reference: registration.reference), status: successful_redirection
    else
      render :new
      false
    end
  end

  protected

  def modify_expiry_date_form
    @modify_expiry_date_form ||= ModifyExpiryDateForm.new(registration)
  end

  def registration
    @registration ||= WasteExemptionsEngine::Registration.find(params[:id])
  end
end
