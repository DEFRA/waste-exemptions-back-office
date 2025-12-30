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

    registration.registration_exemptions.find_each do |re|
      order.order_exemptions.create!(exemption: re.exemption)
    end

    calc = WasteExemptionsEngine::OrderCalculator.new(
      order: order,
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

    operator_address = FactoryBot.build(:address, :operator_address)
    contact_address  = FactoryBot.build(:address, :contact_address)

    site_addresses = (1..number_of_sites).map do |i|
      FactoryBot.build(:address, :site_address).tap do |site|
        site.site_suffix = format("%05d", i)
        site.area ||= "Outside England"
      end
    end

    registration = FactoryBot.build(
      :registration,
      is_multisite_registration: is_multisite,
      registration_exemptions: [],
      addresses: [operator_address, contact_address] + site_addresses
    )

    registration.addresses.each { |a| a.registration = registration }

    site_addresses.each do |site|
      registration_exemptions.each do |registration_exemption|
        copy = registration_exemption.dup
        copy.registration = registration
        copy.address = site

        site.registration_exemptions << copy
        registration.registration_exemptions << copy
      end
    end

    registration.save!
    registration
  end

  def non_production_only
    return if Rails.env.test?

    return unless ["production", nil].include?(ENV.fetch("AIRBRAKE_ENV_NAME", nil))

    raise ActionController::RoutingError, "Not Found"
  end
end
