# frozen_string_literal: true

class ModifyExpiryDateForm
  include ActiveModel::Model

  attr_reader :registration, :date_day, :date_month, :date_year

  def initialize(registration)
    @registration = registration
  end

  def submit(params)
    @date_day = params[:date_day].to_i
    @date_month = params[:date_month].to_i
    @date_year = params[:date_year].to_i

    return false unless expiry_date

    return false unless valid_future_date(expiry_date)

    registration.registration_exemptions.each do |exemption|
      exemption.update(expires_on: expiry_date)
    end

    true
  rescue Date::Error, TypeError => e
    Rails.logger.error "Error parsing registration date, params: #{params}: #{e}"
    Airbrake.notify e, registration: registration.reference
    false
  end

  private

  def expiry_date
    @expiry_date ||= Date.new(date_year, date_month, date_day)
  rescue StandardError
    errors.add :expiry_date, I18n.t(".modify_expiry_date.errors.invalid")
    nil
  end

  def valid_future_date(date)
    return true if date > Time.zone.today

    errors.add :expiry_date, I18n.t(".modify_expiry_date.errors.not_future")
    false
  end
end
