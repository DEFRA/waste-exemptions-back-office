# frozen_string_literal: true

class AddPaymentForm
  include ActiveModel::Model

  attr_reader :registration, :payment_type, :payment_reference, :comments, :payment_amount, :date_day, :date_month,
              :date_year

  def initialize(registration)
    @registration = registration
  end

  def submit(params)
    @payment_type = params[:payment_type]
    @payment_reference = params[:payment_reference]
    @comments = params[:comments]
    @payment_amount = params[:payment_amount]

    @date_day = params[:date_day]
    @date_month = params[:date_month]
    @date_year = params[:date_year]

    return false unless payment_date

    return false unless valid_current_or_past_date(payment_date)

    # registration.registration_exemptions.each do |exemption|
    #   exemption.update(expires_on: expiry_date)
    # end

    true
  rescue Date::Error, TypeError => e
    Rails.logger.error "Error parsing registration date, params: #{params}: #{e}"
    Airbrake.notify e, registration: registration.reference
    false
  end

  private

  def payment_date
    @expiry_date ||= Date.new(date_year, date_month, date_day)
  rescue StandardError
    errors.add :payment_date, I18n.t(".add_payment.errors.date_invalid")
    nil
  end

  def valid_current_or_past_date(date)
    return true if date <= Time.zone.today

    errors.add :payment_date, I18n.t(".add_payment.errors.date_not_current_or_past")
    false
  end
end
