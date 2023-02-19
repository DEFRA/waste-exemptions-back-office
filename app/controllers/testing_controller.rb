# frozen_string_literal: true

require "factory_bot_rails"

class TestingController < ApplicationController

  before_action :non_production_only

  def create_registration
    expiry_date = Date.parse(params[:expiry_date])

    # https://github.com/thoughtbot/factory_bot/blob/ca810767e70ccd85c7cb63f775bc16f653a97dc8/GETTING_STARTED.md#rails-preloaders-and-rspec
    FactoryBot.reload

    registration_exemption = FactoryBot.build(:registration_exemption, expires_on: expiry_date)
    registration = FactoryBot.create(:registration, registration_exemptions: [registration_exemption])

    render :show, locals: { registration: registration }
  end

  private

  def non_production_only
    raise ActionController::RoutingError, "Not Found" if ["production", nil].include?(ENV.fetch("AIRBRAKE_ENV_NAME"))
  end
end
