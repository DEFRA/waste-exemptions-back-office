# frozen_string_literal: true

class SiteDeregistrationsController < ApplicationController
  helper ActionLinksHelper

  def show
    find_resource(params[:registration_reference], params[:id])
    authorize
  end

  private

  def find_resource(reference, site_id)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
    @site = @resource.site_addresses.find(site_id)
  end

  def authorize
    authorize! :read, @resource
  end
end
