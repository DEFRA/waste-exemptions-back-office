# frozen_string_literal: true

load WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "transient_person.rb")

module WasteExemptionsEngine
  class TransientPerson
    include CanBeSearchedLikePerson
  end
end
