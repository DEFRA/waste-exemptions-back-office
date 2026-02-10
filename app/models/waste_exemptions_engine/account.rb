# frozen_string_literal: true

load WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "account.rb")

module WasteExemptionsEngine
  class Account
    delegate :successful_payments, :refunds_and_reversals, to: :payments
  end
end
