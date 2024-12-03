# frozen_string_literal: true

<<<<<<< Updated upstream
require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "payment")
=======
require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "account")
>>>>>>> Stashed changes

module WasteExemptionsEngine
  class Account
    delegate :successful_payments, :refunds_and_reversals, to: :payments
  end
end
