# frozen_string_literal: true

class RegistrationNonPaymentsController < ApplicationController
  REGISTRATIONS_PER_PAGE = 100

  before_action :authorize

  def index
    @registrations = RegistrationNonPaymentsService.run
                                                   .page(params[:page])
                                                   .per(REGISTRATIONS_PER_PAGE)
  end

  private

  def authorize
    authorize! :read, RegistrationNonPaymentsService
  end
end
