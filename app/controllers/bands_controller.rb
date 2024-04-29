# frozen_string_literal: true

class BandsController < ApplicationController
  before_action :authorize

  def index
    @bands = WasteExemptionsEngine::Band.order(sequence: :asc)
    @buckets = WasteExemptionsEngine::Bucket.order(name: :asc)
  end

  def new
    @band = WasteExemptionsEngine::Band.new
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
    authorize! :read, current_user
  end

  def find_band(id)
    @band = WasteExemptionsEngine::Band.find(id)
  end

  def band_params
    params.require(:band)
          .permit(:name, :sequence, :registration_fee, :initial_compliance_charge, :additional_compliance_charge)
  end
end
