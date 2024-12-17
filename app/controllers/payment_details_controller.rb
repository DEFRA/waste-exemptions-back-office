# frozen_string_literal: true

class PaymentDetailsController < ApplicationController
  def index
    find_resource(params[:registration_reference])
    @presenter = AccountPresenter.new(@resource.account)
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end
end
