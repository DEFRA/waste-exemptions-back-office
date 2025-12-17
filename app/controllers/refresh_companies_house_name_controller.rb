# frozen_string_literal: true

require "rest-client"

class RefreshCompaniesHouseNameController < ApplicationController
  include CanSetFlashMessages

  def update_companies_house_details
    reference = params[:reference]
    begin
      RefreshCompaniesHouseNameService.run(reference)
      flash_success(success_message)
    rescue StandardError => e
      Rails.logger.error "Failed to refresh: #{e}"
      flash_error(failure_message, failure_desciption)
    end
    redirect_back_or_to(registration_path(reference))
  end

  private

  def success_message
    I18n.t("refresh_companies_house_name.messages.success")
  end

  def failure_message
    I18n.t("refresh_companies_house_name.messages.failure")
  end

  def failure_desciption
    I18n.t("refresh_companies_house_name.messages.failure_details")
  end
end
