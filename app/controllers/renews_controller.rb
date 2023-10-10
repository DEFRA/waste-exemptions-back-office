# frozen_string_literal: true

class RenewsController < ApplicationController
  include WasteExemptionsEngine::CanRedirectFormToCorrectPath

  def new
    authorize

    # Back office only: Badly formed transient registrations sometimes cause renewals to fail.
    # So we clear any existing transient registrations before starting a back-office renewal.
    WasteExemptionsEngine::TransientRegistration.where(reference: registration.reference).destroy_all

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
      "new_#{@transient_registration.workflow_state}_path".to_sym,
      @transient_registration.token
    )
  end
end
