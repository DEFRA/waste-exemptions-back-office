# frozen_string_literal: true

require "factory_bot_rails"
require "faker"

class TestingController < ApplicationController

  before_action :non_production_only

  def create_registration
    @expiry_date = Date.parse(params[:expiry_date])
    # exemptions from params[:exemptions] which is a list of exemption codes
    # e.g. "create_registration/2022-01-01?exemptions=U1&exemptions=U2&exemptions=U3"
    # "testing/create_registration/2022-01-01?exemptions[]=U4&exemptions[]=U5&exemptions[]=U1"
    registration_exemptions = if params[:exemptions].present?
                                create_registration_exemptions_by_codes(params[:exemptions])
                              else
                                create_registration_exemptions_by_count(3)
                              end

    # https://github.com/thoughtbot/factory_bot/blob/ca810767e70ccd85c7cb63f775bc16f653a97dc8/GETTING_STARTED.md#rails-preloaders-and-rspec
    FactoryBot.reload

    registration = FactoryBot.create(:registration,
                                     registration_exemptions: registration_exemptions)

    # Ensure edit_token_created_at is populated
    registration.regenerate_and_timestamp_edit_token

    # Add an order
    order = FactoryBot.create(:order)
    registration.account.orders << order
    registration_exemptions.map { |re| order.order_exemptions.create!(exemption: re.exemption) }

    # force creation of charge_detail and calculation of balance
    calc = WasteExemptionsEngine::OrderCalculator.new(
      order:,
      strategy_type: WasteExemptionsEngine::RegularChargingStrategy
    )
    calc.charge_detail

    render :show, locals: { registration: registration }
  end

  private

  def create_registration_exemptions_by_count(count)
    selected_exemptions = WasteExemptionsEngine::Exemption.first(count)
    (0..(count - 1)).map do |n|
      FactoryBot.build(:registration_exemption,
                       expires_on: @expiry_date,
                       exemption: selected_exemptions[n] || FactoryBot.create(:exemption))
    end
  end

  def create_registration_exemptions_by_codes(codes)
    WasteExemptionsEngine::Exemption.where(code: codes).map do |exemption|
      FactoryBot.build(:registration_exemption,
                       expires_on: @expiry_date,
                       exemption: exemption)
    end
  end

  def non_production_only
    return if Rails.env.test?

    return unless ["production", nil].include?(ENV.fetch("AIRBRAKE_ENV_NAME", nil))

    raise ActionController::RoutingError, "Not Found"
  end
end
