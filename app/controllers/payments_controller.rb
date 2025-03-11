# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authorize

  def new
    add_payment_form
  end

  def create
    if add_payment_form.submit(payment_params)
      SendRegistrationConfirmationWhenBalanceFullyPaidJob.perform_later(reference: resource.reference)

      successful_redirection = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      redirect_to registration_payment_details_path(reference: resource.reference), status: successful_redirection
    else
      render :new
      false
    end
  end

  private

  def authorize
    authorize! :add_payment, resource
  end

  def resource
    @resource ||= WasteExemptionsEngine::Registration.find_by(reference: params[:registration_reference])
  end

  def add_payment_form
    @account = WasteExemptionsEngine::Account.find_by(registration: resource)
    @add_payment_form ||= AddPaymentForm.new(@account)
  end

  def payment_params
    params.require(:add_payment_form).permit(:payment_type, :payment_amount, :date_year, :date_month, :date_day,
                                             :payment_reference, :comments, :payment_amount_in_pounds)
  end
end
