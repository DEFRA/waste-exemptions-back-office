# frozen_string_literal: true

require "factory_bot_rails"

class TestingController < ApplicationController

  before_action :non_production_only

  def create_registration
    expiry_date = Date.parse(params[:expiry_date])

    # https://github.com/thoughtbot/factory_bot/blob/ca810767e70ccd85c7cb63f775bc16f653a97dc8/GETTING_STARTED.md#rails-preloaders-and-rspec
    FactoryBot.reload

    registration = FactoryBot.create(:registration,
                                     registration_exemptions: FactoryBot.build_list(:registration_exemption,
                                                                                    3,
                                                                                    exemption: find_or_create_exemption,
                                                                                    expires_on: expiry_date))

    render :show, locals: { registration: registration }
  end

  private

  def find_or_create_exemption
    # Use an existing exemption if available, to avoid cluttering the DB
    WasteExemptionsEngine::Exemption.order(Arel.sql("RANDOM()")).first || FactoryBot.create(:exemption)
  end

  def non_production_only
    return if Rails.env.test?

    return unless ["production", nil].include?(ENV.fetch("AIRBRAKE_ENV_NAME", nil))

    raise ActionController::RoutingError, "Not Found"
  end
end
