# frozen_string_literal: true

class SiteExemptionsController < ApplicationController
  def index
    find_resource(params[:registration_reference])
    load_records
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
    @site = @resource.site_addresses.find(params[:site_id])
  end

  def load_records
    @site_registration_exemptions = @site.registration_exemptions
                                         .includes(:registration)
                                         .includes(:exemption)
                                         .order_by_state_then_exemption_id
  end
end
