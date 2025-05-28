# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "payment")

module WasteExemptionsEngine
  class Payment < ApplicationRecord
    scope :not_cancelled, -> { where.not(payment_status: PAYMENT_STATUS_CANCELLED) }
    scope :refunds_and_reversals, lambda {
      where(payment_type: [PAYMENT_TYPE_REFUND, PAYMENT_TYPE_REVERSAL]).order(date_time: :desc).success
    }
    scope :excluding_refunds_and_reversals, -> { where.not(payment_type: [PAYMENT_TYPE_REFUND, PAYMENT_TYPE_REVERSAL]) }
    scope :refundable, lambda {
      where(payment_type: REFUNDABLE_PAYMENT_TYPES)
        .success
        .select { |payment| payment.available_refund_amount.positive? }
    }
    scope :successful_payments, -> { excluding_refunds_and_reversals.success.order(date_time: :desc) }
    scope :reverseable, lambda {
      excluding_refunds_and_reversals
        .success
        .where.not(payment_type: PAYMENT_TYPE_GOVPAY)
        .where.not(id: Payment.where.not(associated_payment_id: nil).select(:associated_payment_id))
        .order(date_time: :desc)
    }

    def total_refunded_amount
      Payment.where(associated_payment_id: id, payment_type: PAYMENT_TYPE_REFUND).sum(:payment_amount).abs
    end

    def total_reversed_amount
      Payment.where(associated_payment_id: id, payment_type: PAYMENT_TYPE_REVERSAL).sum(:payment_amount).abs
    end

    def available_refund_amount
      return 0 unless REFUNDABLE_PAYMENT_TYPES.include?(payment_type)

      remaining_payment_amount = payment_amount - total_refunded_amount - total_reversed_amount
      [remaining_payment_amount, account.balance].min
    end

    def available_for_refund?
      available_refund_amount.positive?
    end
  end
end
