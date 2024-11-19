# frozen_string_literal: true

class ChargeAdjustmentsController < ApplicationController
  def index
    find_resource(params[:registration_reference])
  end

  def new
    setup_form

    redirect_to registration_charge_adjustments_path unless params[:adjustment_type]
  end

  def create
    setup_form

    if @charge_adjustment_form.submit(charge_adjustment_params)
      flash[:success] = t(".success")
      redirect_to registration_payment_details_path(registration_reference: @resource.reference)
    else
      render :new
    end
  end

  private

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
