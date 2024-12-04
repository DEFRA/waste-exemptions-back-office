# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "payment")

module WasteExemptionsEngine
  class Payment
    def maximum_refund_amount
      return unless REFUNDABLE_PAYMENT_TYPES.include?(payment_type)

      [payment_amount, account.balance].min
    end
  end
end
