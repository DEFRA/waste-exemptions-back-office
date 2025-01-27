# frozen_string_literal: true

class RegistrationsController < ApplicationController
  helper ActionLinksHelper

  def show
    resource = find_resource(params[:reference])

    if view_context.private_beta_participant?(resource)
      flash[:message] = I18n.t("registrations.show.private_beta_banner")
    end

    resource
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end
end
