# frozen_string_literal: true

class BetaStartController < ApplicationController
  include CanSetFlashMessages

  def new
    authorize
    return unless ensure_private_beta_active

    @registration = WasteExemptionsEngine::Registration.find_by(reference: params[:registration_reference])
    @participant = WasteExemptionsEngine::BetaParticipant.find_or_initialize_by(
      reg_number: @registration.reference
    )

    if @participant.new_record?
      @participant.email = @registration.contact_email
      @participant.invited_at = Time.current
      @participant.save!
    end

    redirect_to WasteExemptionsEngine::Engine.routes.url_helpers.new_beta_start_form_path(@participant.token)
  end

  private

  def authorize
    authorize! :start_private_beta_registration, WasteExemptionsEngine::Registration
  end

  def ensure_private_beta_active
    return true if WasteExemptionsEngine::FeatureToggle.active?(:private_beta)

    flash[:error] = I18n.t("beta_start.messages.feature_not_active")
    redirect_to registration_path(params[:registration_reference])
    false
  end
end
