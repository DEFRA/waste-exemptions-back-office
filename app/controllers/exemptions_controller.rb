# frozen_string_literal: true

class ExemptionsController < ApplicationController
  include CanSetFlashMessages

  def index
    load_records
  end

  def update
    update_status = UpdateExemptionsService.run(exemption_params)
    if update_status
      flash_success(I18n.t("exemptions.messages.successfully_updated"))
      redirect_to exemptions_path
    else
      load_records
      flash_error(I18n.t("exemptions.messages.failed_to_update"),
                  I18n.t("exemptions.messages.failed_to_update_details"))
      render :index
    end
  end

  private

  def exemption_params
    params.require(:exemptions).permit(exemptions_keys).to_h.transform_keys(&:to_i)
  end

  def exemptions_keys
    params[:exemptions].keys.to_h { |key| [key.to_sym, [:band_id, { bucket_ids: [] }]] }
  end

  def load_records
    @exemptions = WasteExemptionsEngine::Exemption.visible.includes(:bucket_exemptions)
    @bands = WasteExemptionsEngine::Band.all
    @buckets = WasteExemptionsEngine::Bucket.all
  end
end
