# frozen_string_literal: true

class CommunicationLogsController < ApplicationController
  def index
    find_resource(params[:registration_reference])
    authorize! :read, @resource

    @communication_logs = @resource.communication_logs.order(created_at: :desc).page(params[:page]).per(10)
  end

  protected

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end
end
