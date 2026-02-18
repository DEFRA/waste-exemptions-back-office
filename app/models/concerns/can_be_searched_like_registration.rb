# frozen_string_literal: true

module CanBeSearchedLikeRegistration
  extend ActiveSupport::Concern

  included do
    # Allow classes using the concern to extend scope logic
    scope :base_search_registration_and_relations, lambda { |term|
      where(id: search_registration(term).ids +
                search_for_site_address_postcode(term).ids +
                search_for_contact_address_postcode(term).ids +
                search_for_operator_address_postcode(term).ids +
                search_for_person_name(term).ids +
                search_for_telephone(term).ids)
        .order(created_at: :desc)
    }

    scope :search_registration_and_relations, lambda { |term|
      base_search_registration_and_relations(term)
    }

    scope :search_registration, lambda { |term|
      where(
        "UPPER(contact_email) = ?\
          OR UPPER(CONCAT(contact_first_name, ' ', contact_last_name)) LIKE ?\
          OR UPPER(operator_name) LIKE ?\
          OR UPPER(reference) = ?",
        term&.upcase,        # contact_email
        "%#{term&.upcase}%", # contact names
        "%#{term&.upcase}%", # operator_name
        term&.upcase         # reference
      )
    }
  end
end
