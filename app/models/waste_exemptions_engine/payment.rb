# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "payment")

module WasteExemptionsEngine
  class Payment
    scope :not_cancelled, -> { where.not(payment_status: PAYMENT_STATUS_CANCELLED) }
    scope :refunds_and_reversals, lambda {
      where(payment_type: [PAYMENT_TYPE_REFUND, PAYMENT_TYPE_REVERSAL]).order(date_time: :desc)
    }
    scope :excluding_refunds_and_reversals, -> { where.not(payment_type: [PAYMENT_TYPE_REFUND, PAYMENT_TYPE_REVERSAL]) }
    scope :refundable, -> { where(payment_type: REFUNDABLE_PAYMENT_TYPES) }
    scope :successful_payments, -> { excluding_refunds_and_reversals.success.order(date_time: :desc) }
    scope :reverseable, lambda {
      excluding_refunds_and_reversals
        .success
        .where.not(payment_type: PAYMENT_TYPE_GOVPAY)
        .where.not(id: Payment.where.not(associated_payment_id: nil).select(:associated_payment_id))
    }

  end
end
