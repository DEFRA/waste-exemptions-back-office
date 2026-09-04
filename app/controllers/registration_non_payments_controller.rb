# frozen_string_literal: true

class RegistrationNonPaymentsController < ApplicationController
  REGISTRATIONS_PER_PAGE = 100

  before_action :authorize

  def index
    respond_to do |format|
      format.html do
        @registrations = RegistrationNonPaymentsService.run
                                                       .page(params[:page])
                                                       .per(REGISTRATIONS_PER_PAGE)
      end

      format.csv do
        timestamp = Time.zone.now.strftime("%Y-%m-%d_%H:%M")
        send_data Reports::RegistrationNonPaymentsExportService.run,
                  filename: "registration_non_payments_#{timestamp}.csv"
      end
    end
  end

  private

  def authorize
    authorize! :read, RegistrationNonPaymentsService
  end
end
