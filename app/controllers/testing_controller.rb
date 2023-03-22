# frozen_string_literal: true

require "factory_bot_rails"

class TestingController < ApplicationController

  before_action :non_production_only

  def create_registration
    @expiry_date = Date.parse(params[:expiry_date])

    # https://github.com/thoughtbot/factory_bot/blob/ca810767e70ccd85c7cb63f775bc16f653a97dc8/GETTING_STARTED.md#rails-preloaders-and-rspec
    FactoryBot.reload

    registration = FactoryBot.create(:registration,
                                     registration_exemptions: registration_exemptions(3))

    render :show, locals: { registration: registration }
  end

  private

  def registration_exemptions(count)
    selected_exemptions = WasteExemptionsEngine::Exemption.first(count)
    (0..count - 1).map do |n|
      FactoryBot.build(:registration_exemption,
                       expires_on: @expiry_date,
                       exemption: selected_exemptions[n] || FactoryBot.create(:exemption))
    end
  end

  def non_production_only
    return if Rails.env.test?

    return unless ["production", nil].include?(ENV.fetch("AIRBRAKE_ENV_NAME", nil))

    raise ActionController::RoutingError, "Not Found"
  end
end
