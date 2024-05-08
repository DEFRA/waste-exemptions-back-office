# frozen_string_literal: true

class BandsController < ApplicationController
  before_action :authorize

  def index
    @bands = WasteExemptionsEngine::Band.order(sequence: :asc)
    @buckets = WasteExemptionsEngine::Bucket.order(name: :asc)
    @registration_charge = WasteExemptionsEngine::Charge.find_by(charge_type: :registration_charge)
  end

  def new
    @band = WasteExemptionsEngine::Band.new
    @band.initial_compliance_charge = WasteExemptionsEngine::Charge.new(charge_type: :initial_compliance_charge)
    @band.additional_compliance_charge = WasteExemptionsEngine::Charge.new(charge_type: :additional_compliance_charge)
  end

  def edit
    find_band(params[:id])
  end

  def create
    @band = WasteExemptionsEngine::Band.new(band_params)

    if @band.save
      redirect_to bands_url
    else
      render :new
    end
  end

  def update
    find_band(params[:id])

    if @band.update(band_params)
      redirect_to bands_url
    else
      render :edit
    end
  end

  private

  def authorize
    authorize! :manage_charges, :all
  end

  def find_band(id)
    @band = WasteExemptionsEngine::Band.find(id)
  end

  def band_params
    params.require(:band)
          .permit(
            :name,
            :sequence,
            :registration_charge,
            initial_compliance_charge_attributes: %i[id charge_amount_in_pounds],
            additional_compliance_charge_attributes: %i[id charge_amount_in_pounds]
          ).tap do |params|
      # @TODO: this logic needs to be moved to a form object once requirements are clear
      if params[:initial_compliance_charge_attributes]
        params[:initial_compliance_charge_attributes][:name] = "initial compliance charge"
        params[:initial_compliance_charge_attributes][:charge_type] = "initial_compliance_charge"
      end
      if params[:additional_compliance_charge_attributes]
        params[:additional_compliance_charge_attributes][:name] = "additional compliance charge"
        params[:additional_compliance_charge_attributes][:charge_type] = "additional_compliance_charge"
      end
    end
  end
end
