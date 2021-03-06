# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "person")

module WasteExemptionsEngine
  class Person
    include CanBeSearchedLikePerson
  end
end
