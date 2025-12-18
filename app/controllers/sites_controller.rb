# frozen_string_literal: true

class SitesController < ApplicationController
  helper ActionLinksHelper

  def index
    find_resource(params[:registration_reference])

    @site_addresses = @resource.site_addresses.includes([:registration_exemptions])
                               .page(params[:page]).order(:id).per(20)
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end
end
