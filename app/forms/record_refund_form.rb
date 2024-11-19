# frozen_string_literal: true

class RecordRefundForm
  include ActiveModel::Model

  attr_accessor :payment_id, :amount, :comments

  validates :amount,
            "defra_ruby/validators/price": true,
            presence: true,
            numericality: { greater_than: 0 }
  validate :payment_exists
  validate :amount_within_limits, if: -> { payment.present? }
  validates :comments, presence: true

  def submit(params, record_refund_service: RecordRefundService)
    self.amount = params[:amount]
    self.comments = params[:comments]
    self.payment_id = params[:payment_id]

    @payment = WasteExemptionsEngine::Payment.find_by(id: payment_id)
    @balance = payment&.account&.balance&./(100)

    return false unless valid?

    Rails.logger.info "running RecordRefundService with arguments: #{comments}, #{payment}, #{amount.to_f}"

    record_refund_service.run(
      comments: comments,
      payment: payment,
      amount_in_pounds: amount.to_f
    )
  end

  private

  attr_reader :payment, :balance

  def payment_exists
    return if payment_id.blank?
    return if WasteExemptionsEngine::Payment.exists?(id: payment_id)

    errors.add(:payment, :payment_missing)
  end

  def amount_within_limits
    return if amount.blank? || !amount.to_f.positive?

    errors.add(:amount, :exceeds_payment_amount) if amount.to_f > payment.payment_amount.to_f / 100

    return unless amount.to_f > balance

    errors.add(:amount, :exceeds_balance)
  end
end
