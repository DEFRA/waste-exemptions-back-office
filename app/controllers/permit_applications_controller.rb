# frozen_string_literal: true

class PermitApplicationsController < ApplicationController
  include CanSetFlashMessages

  before_action :authorize
  before_action :redirect_unless_can_be_marked, only: %i[new create]
  before_action :redirect_unless_marked, only: %i[edit update destroy]

  def new
    @permit_application_form = PermitApplicationForm.new(registration: @resource)
  end

  def edit
    @permit_application_form = PermitApplicationForm.new(
      registration: @resource,
      permit_application_number: @resource.permit_application_number,
      permit_application_status: @resource.permit_application_status
    )
  end

  def create
    submit_form(:new)
  end

  def update
    submit_form(:edit)
  end

  def destroy
    @resource.update(
      permit_application_number: nil,
      permit_application_status: nil,
      reason_for_change: t(".reason_for_change")
    )
    flash_success(t(".success"))
    redirect_to registration_path(@resource.reference)
  end

  private

  def authorize
    @resource = WasteExemptionsEngine::Registration.find_by(reference: params[:registration_reference])
    authorize! :manage_permit_application, @resource
  end

  def redirect_unless_can_be_marked
    return if @resource.active? && !@resource.permit_application_in_progress?

    redirect_to registration_path(@resource.reference)
  end

  def redirect_unless_marked
    return if @resource.permit_application_in_progress?

    redirect_to registration_path(@resource.reference)
  end

  def submit_form(template)
    @permit_application_form = PermitApplicationForm.new(registration: @resource)

    if @permit_application_form.submit(permit_application_params)
      flash_success(t(".success"))
      redirect_to registration_path(@resource.reference)
    else
      render template
    end
  end

  def permit_application_params
    params.fetch(:permit_application_form, {}).permit(:permit_application_number, :permit_application_status)
  end
end
