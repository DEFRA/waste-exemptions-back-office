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
    authorize! :read, current_user
  end

  def find_bucket(id)
    @bucket = WasteExemptionsEngine::Bucket.find(id)
  end

  def bucket_params
    params.require(:bucket)
          .permit(:name, :charge_amount)
  end
end
