# frozen_string_literal: true

class BucketsController < ApplicationController
  before_action :authorize

  def edit
    find_bucket(params[:id])
  end

  def update
    find_bucket(params[:id])

    if @bucket.update(bucket_params)
      redirect_to bands_url
    else
      render :edit
    end
  end

  private

  def authorize
    authorize! :manage_charges, :all
  end

  def find_bucket(id)
    @bucket = WasteExemptionsEngine::Bucket.find(id)
  end

  def bucket_params
    params.require(:bucket)
          .permit(
            :name,
            :charge_amount,
            initial_compliance_charge_attributes: %i[id charge_amount_in_pounds]
          ).tap do |params|
            params[:initial_compliance_charge_attributes][:name] = "initial compliance charge"
            params[:initial_compliance_charge_attributes][:charge_type] = "initial_compliance_charge"
          end
  end
end
