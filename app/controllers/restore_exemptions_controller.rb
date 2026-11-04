# frozen_string_literal: true

class RestoreExemptionsController < ApplicationController
  def new
    setup_form
    return render :blocked if blocked?

    render :new
  end

  def update
    setup_form
    return render :blocked if blocked?

    restoration_service = RestorationService.new(current_user, @resource)

    if @restore_exemptions_form.submit(params[:restore_exemptions_form], restoration_service)
      successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      redirect_to successful_redirect_path, status: successful_redirection
    else
      render :new
    end
  end

  protected

  def setup_form
    find_resource(params[:id])
    @restore_exemptions_form ||= RestoreExemptionsForm.new
    @restorations = RestorationsPresenter.new(@resource)
    authorize! :restore, @resource
  end

  # Only whole-registration restores can be blocked: an individual exemption is
  # never ambiguous.
  def blocked?
    false
  end

  def find_resource(id)
    @resource = WasteExemptionsEngine::RegistrationExemption.find(id)
  end

  def successful_redirect_path
    registration_path(reference: @resource.registration.reference)
  end
end
