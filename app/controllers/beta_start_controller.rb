# frozen_string_literal: true

class BetaStartController < ApplicationController
  def new
    authorize
    return unless ensure_private_beta_active

    @registration = WasteExemptionsEngine::Registration.find_by(reference: params[:registration_reference])
    @participant = WasteExemptionsEngine::BetaParticipant.find_or_create_by(
      email: @registration.contact_email,
      reg_number: @registration.reference
    )
    redirect_to WasteExemptionsEngine::Engine.routes.url_helpers.new_beta_start_form_path(@participant.token)
  end

  private

  def authorize
    authorize! :start_private_beta_registration, WasteExemptionsEngine::Registration
  end

  def ensure_private_beta_active
    return true if WasteExemptionsEngine::FeatureToggle.active?(:private_beta)

    redirect_to "/pages/permission"
    false
  end
end
