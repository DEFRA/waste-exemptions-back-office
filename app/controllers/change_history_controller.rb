# frozen_string_literal: true

class ChangeHistoryController < ApplicationController
  def index
    find_resource(params[:registration_reference])
    authorize! :read, @resource

    @change_history = RegistrationChangeHistoryService.run(@resource).reverse
  end

  protected

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end
end
