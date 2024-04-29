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
    # copy registration_fee from the first band
    if WasteExemptionsEngine::Band.count.positive?
      @band.registration_fee = WasteExemptionsEngine::Band.first.registration_fee
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

  def edit_registration_fee
    if WasteExemptionsEngine::Band.count.zero?
      flash[:error] = t(".errors.create_bands_first")
      redirect_to bands_url
    else
      @band = WasteExemptionsEngine::Band.first
    end
  end

  def update_registration_fee
    begin
      WasteExemptionsEngine::Band.transaction do
        WasteExemptionsEngine::Band.all.each do |band|
          band.update!(registration_fee_params)
        end
      end

      redirect_to bands_url
    rescue ActiveRecord::RecordInvalid
      @band = WasteExemptionsEngine::Band.first
      @band.errors.add(:registration_fee, t(".invalid_registration_fee"))
      render :edit_registration_fee
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

  def registration_fee_params
    params.require(:band)
          .permit(:registration_fee)
  end
end
