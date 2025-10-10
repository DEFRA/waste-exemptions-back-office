# frozen_string_literal: true

class DeregisterSitesController < DeregisterExemptionsController

  protected

  def find_resource(id)
    @resource = WasteExemptionsEngine::Address.find(id)
  end

  def registration_reference
    @resource.reference
  end
end
