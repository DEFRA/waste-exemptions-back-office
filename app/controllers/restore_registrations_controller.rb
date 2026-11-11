# frozen_string_literal: true

class RestoreRegistrationsController < RestoreExemptionsController

  protected

  def blocked?
    @resource.previously_deregistered_exemptions?
  end

  def find_resource(id)
    @resource = WasteExemptionsEngine::Registration.find(id)
  end

  def successful_redirect_path
    registration_path(reference: @resource.reference)
  end
end
