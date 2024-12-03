# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "account")

module WasteExemptionsEngine
  class Account
    delegate :successful_payments, :refunds_and_reversals, to: :payments
  end
end
