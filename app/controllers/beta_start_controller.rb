# frozen_string_literal: true

class BetaStartController < ApplicationController
  def new
    authorize

    @registration = WasteExemptionsEngine::Registration.find_by(reference: params[:registration_reference])
    @participant = WasteExemptionsEngine::BetaParticipant.create(email: @registration.contact_email)
    redirect_to WasteExemptionsEngine::Engine.routes.url_helpers.new_beta_start_form_path(@participant.token)
  end

  def authorize
    # nada
  end
end
