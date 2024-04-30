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
    # copy registration_charge from the first band
    if WasteExemptionsEngine::Band.count.positive?
      @band.registration_charge = WasteExemptionsEngine::Band.first.registration_charge
    else
      @band.registration_charge = 0
    end

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

  def edit_registration_charge
    if WasteExemptionsEngine::Band.count.zero?
      flash[:error] = t(".errors.create_bands_first")
      redirect_to bands_url
    else
      @band = WasteExemptionsEngine::Band.first
    end
  end

  def update_registration_charge
    begin
      WasteExemptionsEngine::Band.transaction do
        WasteExemptionsEngine::Band.all.each do |band|
          band.update!(registration_charge_params)
        end
      end

      redirect_to bands_url
    rescue ActiveRecord::RecordInvalid => e
      @band = WasteExemptionsEngine::Band.first
      @band.errors.add(:registration_charge, e.message.gsub('Validation failed: Registration fee ', ''))
      render :edit_registration_charge
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
          .permit(:name, :sequence, :registration_charge, :initial_compliance_charge, :additional_compliance_charge)
  end

  def registration_charge_params
    params.require(:band)
          .permit(:registration_charge)
  end
end
