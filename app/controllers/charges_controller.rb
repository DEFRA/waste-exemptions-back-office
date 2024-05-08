# frozen_string_literal: true

class ChargesController < ApplicationController
  before_action :authorize

  def edit
    find_charge(params[:id])
  end

  def update
    find_charge(params[:id])

    if @charge.update(charge_params)
      redirect_to bands_url
    else
      render :edit
    end
  end

  private

  def authorize
    authorize! :manage_charges, :all
  end

  def find_charge(id)
    @charge = WasteExemptionsEngine::Charge.find(id)
  end

  def charge_params
    params.require(:charge)
          .permit(
            :name,
            :charge_amount_in_pounds
          )
  end
end
