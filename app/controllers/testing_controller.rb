# frozen_string_literal: true

require "factory_bot_rails"

class TestingController < ApplicationController

  before_action :non_production_only

  def create_registration
    @expiry_date = Date.parse(params[:expiry_date])
    # exemptions from params[:exemptions] which is a list of exemption codes
    # e.g. "create_registration/2022-01-01?exemptions=U1&exemptions=U2&exemptions=U3"
    # "testing/create_registration/2022-01-01?exemptions[]=U4&exemptions[]=U5&exemptions[]=U1"
    registration_exemptions = if params[:exemptions].present?
                                 registration_exemptions_by_codes(params[:exemptions])
                               else
                                 registration_exemptions_by_count(3)
                               end
    # https://github.com/thoughtbot/factory_bot/blob/ca810767e70ccd85c7cb63f775bc16f653a97dc8/GETTING_STARTED.md#rails-preloaders-and-rspec
    FactoryBot.reload

    registration = FactoryBot.create(:registration,
                                     registration_exemptions: registration_exemptions_by_count(3))

    # Ensure edit_token_created_at is populated
    registration.regenerate_and_timestamp_edit_token

    render :show, locals: { registration: registration, registration_exemptions: registration_exemptions }
  end

  private

  def registration_exemptions_by_count(count)
    selected_exemptions = WasteExemptionsEngine::Exemption.first(count)
    (0..count - 1).map do |n|
      FactoryBot.build(:registration_exemption,
                       expires_on: @expiry_date,
                       exemption: selected_exemptions[n] || FactoryBot.create(:exemption))
    end
  end

  def registration_exemptions_by_codes(codes)
    selected_exemptions = WasteExemptionsEngine::Exemption.where(code: codes)
    codes.map do |code|
      FactoryBot.build(:registration_exemption,
                       expires_on: @expiry_date,
                       exemption: selected_exemptions.find do |exemption|
                                    exemption.code == code
                                  end || FactoryBot.create(:exemption, code: code))
    end
  end

  def non_production_only
    return if Rails.env.test?

    return unless ["production", nil].include?(ENV.fetch("AIRBRAKE_ENV_NAME", nil))

    raise ActionController::RoutingError, "Not Found"
  end
end
