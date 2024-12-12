# frozen_string_literal: true

class AdjustmentTypesController < ApplicationController
  def new
    find_resource(params[:registration_reference])
    @adjustment_type_form = AdjustmentTypeForm.new
  end

  def create
    find_resource(params[:registration_reference])
    @adjustment_type_form = AdjustmentTypeForm.new

    form_params = params[:adjustment_type_form] || { adjustment_type: nil }

    if @adjustment_type_form.submit(form_params)
      redirect_to new_registration_charge_adjustment_path(
        registration_reference: @resource.reference,
        adjustment_type: @adjustment_type_form.adjustment_type
      )
    else
      render :new
    end
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end
end
