# frozen_string_literal: true

class RegistrationsController < ApplicationController
  helper ActionLinksHelper

  def show
    find_resource(params[:reference])
    authorize
  end

  def update_companies_house_details
    reference = params[:reference]
    WasteExemptionsEngine::RefreshCompaniesHouseNameService.run(reference)

    redirect_back(fallback_location: registration_path(reference))
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def authorize
    authorize! :read, @resource
  end
end
