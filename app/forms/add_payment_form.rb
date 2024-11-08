# frozen_string_literal: true

class AddPaymentForm
  include ActiveModel::Model

  attr_reader :account, :payment_type, :payment_reference, :comments, :payment_amount, :date_day, :date_month,
              :date_year

  validates :payment_type,
            inclusion: { in: %w[bank_transfer missing_card_payment other_payment],
                         message: I18n.t(".payments.errors.payment_type_invalid") }
  validates :payment_amount, presence: { message: I18n.t(".payments.errors.payment_amount_blank") },
                             numericality: {
                               greater_than: 0,
                               message: I18n.t(".payments.errors.payment_amount_invalid")
                             }
  validates :payment_reference, presence: { message: I18n.t(".payments.errors.payment_reference_blank") }

  validate :validate_payment_date_current_or_past

  def initialize(account)
    @account = account
  end

  def submit(params)
    @payment_type = params[:payment_type]
    @payment_reference = params[:payment_reference]
    @comments = params[:comments]
    @payment_amount = params[:payment_amount]

    @date_day = params[:date_day].to_i if params[:date_day].present?
    @date_month = params[:date_month].to_i if params[:date_month].present?
    @date_year = params[:date_year].to_i if params[:date_year].present?

    if valid?
      payment = init_payment
      return payment.save! if payment.valid?
    end

    false
  end

  private

  def init_payment
    WasteExemptionsEngine::Payment.new(
      payment_type: payment_type,
      payment_amount: WasteExemptionsEngine::CurrencyConversionService.convert_pounds_to_pence(payment_amount),
      payment_status: WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS,
      date_time: Date.new(date_year.to_i, date_month.to_i, date_day.to_i),
      payment_uuid: SecureRandom.uuid,
      reference: payment_reference,
      account: account,
      comments: comments
    )
  end

  def validate_payment_date_current_or_past
    date ||= Date.new(date_year, date_month, date_day)
    return if date <= Time.zone.today

    errors.add :payment_date, I18n.t(".payments.errors.date_not_current_or_past")
  rescue StandardError
    errors.add :payment_date, I18n.t(".payments.errors.date_invalid")
  end
end
