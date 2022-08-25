# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "new_registration")

module WasteExemptionsEngine
  class NewRegistration < TransientRegistration
    include CanBeSearchedLikeRegistration
    include CanBeSearchedLikeTelephone

    scope :search_for_site_address_postcode, lambda { |term|
      joins(:transient_addresses).merge(TransientAddress.search_for_postcode(term).site)
    }

    scope :search_for_person_name, lambda { |term|
      joins(:transient_people).merge(TransientPerson.search_for_name(term))
    }
  end
end
