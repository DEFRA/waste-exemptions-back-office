# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "payment")

module WasteExemptionsEngine
  class Payment < ApplicationRecord
    scope :not_cancelled, -> { where.not(payment_status: PAYMENT_STATUS_CANCELLED) }
    scope :refunds_and_reversals, lambda {
      where(payment_type: [PAYMENT_TYPE_REFUND, PAYMENT_TYPE_REVERSAL]).order(date_time: :desc).success
    }
    scope :excluding_refunds_and_reversals, -> { where.not(payment_type: [PAYMENT_TYPE_REFUND, PAYMENT_TYPE_REVERSAL]) }
    scope :refundable, -> { where(payment_type: REFUNDABLE_PAYMENT_TYPES).success }
    scope :successful_payments, -> { excluding_refunds_and_reversals.success.order(date_time: :desc) }

    def maximum_refund_amount
      return unless REFUNDABLE_PAYMENT_TYPES.include?(payment_type)

      [payment_amount, account.balance].min
    end
  end
end
