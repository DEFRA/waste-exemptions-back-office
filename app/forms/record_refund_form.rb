# frozen_string_literal: true

class RecordRefundForm
  include ActiveModel::Model

  attr_accessor :comments, :payment_id, :amount

  validates :comments, presence: true
  validates :payment_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :amount_within_limits

  def initialize(attributes = {})
    super
  end

  def submit(params, record_refund_service: RecordRefundService)
    self.amount = params[:amount]
    self.comments = params[:comments]
    self.payment_id = params[:payment_id]

    @payment = WasteExemptionsEngine::Payment.find_by(id: payment_id)
    @balance = payment.account.balance

    return false unless valid?

    Rails.logger.info "running RecordRefundService with arguments: #{comments}, #{payment}, #{amount.to_f}"
    record_refund_service.run(comments: comments,
                              payment: payment,
                              amount_in_pounds: amount.to_f)
  end

  private

  attr_reader :payment, :max_amount, :balance

  def amount_within_limits
    return if amount.blank? || !amount.to_f.positive?

    if amount.to_f > payment.payment_amount.to_f / 100
      errors.add(:amount, I18n.t(".record_refunds.form.errors.exceeds_payment_amount"))
    end

    return if balance.negative? || amount.to_f <= balance

    errors.add(:amount, I18n.t(".record_refunds.form.errors.exceeds_balance"))
  end

  def reason_present_in_comments
    return if comments.present?

    errors.add(:comments, I18n.t(".record_refunds.form.errors.reason_missing"))
  end
end
