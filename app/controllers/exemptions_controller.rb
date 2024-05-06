# frozen_string_literal: true

class ExemptionsController < ApplicationController
  def index
    @exemptions = WasteExemptionsEngine::Exemption.visible.includes(:band, :bucket_exemptions)
    @bands = WasteExemptionsEngine::Band.all
    @buckets = WasteExemptionsEngine::Bucket.all
  end

  def update
    update_status = UpdateExemptionsService.run(exemption_params)
    if update_status
      redirect_to exemptions_path, notice: 'Exemptions updated successfully.'
    else
      @exemptions = WasteExemptionsEngine::Exemption.visible.includes(:band, :bucket_exemptions)
      @bands = WasteExemptionsEngine::Band.all
      @buckets = WasteExemptionsEngine::Bucket.all
      flash.now[:error] = 'Failed to update exemptions.'
      render :index
    end
  end

  private

  def exemption_params
    params.require(:exemptions).permit!
  end
end
