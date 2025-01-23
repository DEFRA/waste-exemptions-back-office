# frozen_string_literal: true

class NewRegistrationsController < ApplicationController
  helper ActionLinksHelper
  helper RegistrationsHelper

  def show
    find_resource(params[:id])
    authorize
  end

  private

  def find_resource(id)
    @resource = WasteExemptionsEngine::NewRegistration.find_by(id: id)
    return unless @resource.nil?

    @resource = WasteExemptionsEngine::NewChargedRegistration.find(id)
  end

  def authorize
    authorize! :read, @resource
  end
end
