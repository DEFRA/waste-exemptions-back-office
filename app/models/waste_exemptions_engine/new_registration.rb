# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "new_registration")

module WasteExemptionsEngine
  class NewRegistration < TransientRegistration
  end
end
