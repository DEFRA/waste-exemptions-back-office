# frozen_string_literal: true

load WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "transient_address.rb")

module WasteExemptionsEngine
  class TransientAddress
    include CanBeSearchedLikeAddress
  end
end
