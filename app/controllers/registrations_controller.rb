# frozen_string_literal: true

class RegistrationsController < ApplicationController
  helper ActionLinksHelper

  def show
    find_resource(params[:reference])
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end
end
