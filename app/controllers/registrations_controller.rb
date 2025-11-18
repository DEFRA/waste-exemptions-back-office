# frozen_string_literal: true

class RegistrationsController < ApplicationController
  include CanSetFlashMessages

  helper ActionLinksHelper

  before_action :authorize

  def show
    find_resource(params[:reference])
  end

  def linear
    @registrations = WasteExemptionsEngine::Registration
                     .linear
                     .includes(:registration_exemptions, :site_address)
                     .order(:reference)
                     .page(params[:page])
  end

  def mark_as_legacy_bulk
    registration_reference = params[:registration_reference]
    find_resource(registration_reference).update(is_legacy_bulk: true)
    flash_success(I18n.t("registrations.marked_as_legacy_bulk"))
    redirect_to registration_path(registration_reference)
  end

  def mark_as_legacy_linear
    registration_reference = params[:registration_reference]
    find_resource(registration_reference).update!(is_linear: true)
    flash_success(I18n.t("registrations.marked_as_legacy_linear"))
    redirect_to registration_path(registration_reference)
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def authorize
    authorize! :read, WasteExemptionsEngine::Registration
  end
end
