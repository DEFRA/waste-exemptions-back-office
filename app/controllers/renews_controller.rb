# frozen_string_literal: true

class RenewsController < ApplicationController
  include WasteExemptionsEngine::CanRedirectFormToCorrectPath

  def new
    authorize

    @transient_registration = WasteExemptionsEngine::RenewalStartService.run(registration: registration)
    @transient_registration.aasm.enter_initial_state
    redirect_to_correct_form
  end

  private

  def registration
    @_registration ||= WasteExemptionsEngine::Registration.find_by(reference: params[:reference])
  end

  def authorize
    authorize! :renew, registration
  end

  def form_path
    @transient_registration.save if @transient_registration.token.blank?

    WasteExemptionsEngine::Engine.routes.url_helpers.send(
      :"new_#{@transient_registration.workflow_state}_path",
      @transient_registration.token
    )
  end
end
