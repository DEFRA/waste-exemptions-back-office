# frozen_string_literal: true

require "factory_bot_rails"
require "faker"

class TestingController < ApplicationController

  before_action :non_production_only

  def create_registration
    @expiry_date = Date.parse(params[:expiry_date])
    registration_exemptions = build_registration_exemptions

    # https://github.com/thoughtbot/factory_bot/blob/ca810767e70ccd85c7cb63f775bc16f653a97dc8/GETTING_STARTED.md#rails-preloaders-and-rspec
    FactoryBot.reload

    number_of_sites = params[:number_of_sites].present? ? params[:number_of_sites].to_i : 1
    registration = create_registration_with_sites(number_of_sites, registration_exemptions)

    # Ensure edit_token_created_at is populated
    registration.regenerate_and_timestamp_edit_token

    # Add an order and calculate charges
    add_order_and_calculate_charges(registration)

    render :show, locals: { registration: registration }
  end

  private

  # exemptions from params[:exemptions] which is a list of exemption codes
  # e.g. "create_registration/2022-01-01?exemptions=U1&exemptions=U2&exemptions=U3"
  # "testing/create_registration/2022-01-01?exemptions[]=U4&exemptions[]=U5&exemptions[]=U1"
  def build_registration_exemptions
    if params[:exemptions].present?
      create_registration_exemptions_by_codes(params[:exemptions])
    else
      create_registration_exemptions_by_count(3)
    end
  end

  def add_order_and_calculate_charges(registration)
    order = FactoryBot.create(:order)
    registration.account.orders << order

    registration_exemptions = registration.site_addresses.flat_map(&:registration_exemptions)
    registration_exemptions.each { |re| order.order_exemptions.create!(exemption: re.exemption) }

    # force creation of charge_detail and calculation of balance
    calc = WasteExemptionsEngine::OrderCalculator.new(
      order:,
      strategy_type: WasteExemptionsEngine::RegularChargingStrategy
    )
    calc.charge_detail
  end

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

  def create_registration_with_sites(number_of_sites, registration_exemptions)
    is_multisite = number_of_sites > 1

    FactoryBot.create(:registration, is_multisite_registration: is_multisite,
                                     registration_exemptions: registration_exemptions).tap do |registration|
      if is_multisite
        registration.site_addresses = (1..number_of_sites).map do |i|
          site_address = FactoryBot.build(:address, :site_address)
          site_address.registration_exemptions = registration_exemptions.map(&:dup)
          site_address.site_suffix = format("%05d", i)
          site_address
        end
      else
        # For single-site, also attach exemptions to the site address
        site_address = registration.site_addresses.find { |a| a.address_type == "site" }
        site_address.registration_exemptions = registration_exemptions if site_address
      end

      registration.save!
    end
  end

  def non_production_only
    return if Rails.env.test?

    return unless ["production", nil].include?(ENV.fetch("AIRBRAKE_ENV_NAME", nil))

    raise ActionController::RoutingError, "Not Found"
  end
end
