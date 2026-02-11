# frozen_string_literal: true

load WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "person.rb")

module WasteExemptionsEngine
  class Person
    include CanBeSearchedLikePerson
  end
end
