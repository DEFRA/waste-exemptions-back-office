# frozen_string_literal: true

class RecordRefundForm
  include ActiveModel::Model

  attr_accessor :payment_id, :amount, :comments

  validates :amount,
            "defra_ruby/validators/price": true,
            presence: true,
            numericality: { greater_than: 0 }
  validate :amount_within_limits, if: -> { payment.present? }
  validates :comments, presence: true

  def submit(params)
    self.amount = params[:amount]
    self.comments = params[:comments]
    self.payment_id = params[:payment_id]

    return false unless check_payment_exists?

    @payment = WasteExemptionsEngine::Payment.find_by(id: payment_id)

    @balance = payment.account.balance

    return false unless valid?

    Rails.logger.info "running RecordRefundService with arguments: #{comments}, #{payment}, #{amount.to_f}"

    RecordRefundService.run(
      comments: comments,
      payment: payment,
      amount_in_pence: amount_in_pence
    )
  end

  private

  attr_reader :payment, :balance

  def check_payment_exists?
    return true if WasteExemptionsEngine::Payment.exists?(id: payment_id)

    errors.add(:payment, :payment_missing)
    false
  end

  def amount_within_limits
    return if amount.blank? || !amount.to_i.positive?

    errors.add(:amount, :exceeds_payment_amount) if amount_in_pence > payment.payment_amount.to_f

    return unless amount_in_pence > balance

    errors.add(:amount, :exceeds_balance)
  end

  def amount_in_pence
    WasteExemptionsEngine::CurrencyConversionService.convert_pounds_to_pence(amount.to_i)
  end
end
