# frozen_string_literal: true

class ChargeAdjustmentsController < ApplicationController
  before_action :authorize

  def new
    setup_form
    return if params[:adjustment_type]

    redirect_to new_registration_adjustment_type_path(registration_reference: @resource.reference)
  end

  def create
    setup_form

    if @charge_adjustment_form.submit(charge_adjustment_params)
      flash[:success] = t(".success")
      SendRegistrationConfirmationWhenBalanceFullyPaidJob.perform_later(reference: @resource.reference)
      redirect_to registration_payment_details_path(registration_reference: @resource.reference)
    else
      render :new
    end
  end

  private

  def authorize
    resource = find_resource(params[:registration_reference])
    authorize! :add_charge_adjustment, resource
  end

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def setup_form
    find_resource(params[:registration_reference])
    @charge_adjustment_form = ChargeAdjustmentForm.new(
      adjustment_type: params[:adjustment_type],
      account: @resource.account
    )
  end

  def charge_adjustment_params
    params.require(:charge_adjustment_form).permit(:adjustment_type, :amount, :reason)
  end
end
