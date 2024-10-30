# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authorize

  def new
    add_payment_form
  end

  def create
    if @add_payment_form.submit(params[:add_payment_form])
      successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      redirect_to registration_path(reference: registration.reference), status: successful_redirection
    else
      render :new
      false
    end
  end

  private

  def authorize
    authorize! :manage_charges, :all
  end

  def resource
    @resource ||= WasteExemptionsEngine::Registration.find_by(reference: params[:registration_reference])
  end

  def add_payment_form
    @add_payment_form ||= AddPaymentForm.new(resource)
  end

  def payment_params
    params.require(:payment).permit(:amount, :date, :reference)
  end
end
