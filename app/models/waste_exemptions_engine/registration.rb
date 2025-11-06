# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration")

module WasteExemptionsEngine
  class Registration < WasteExemptionsEngine::ApplicationRecord
    include CanBeSearchedLikeRegistration
    include CanBeSearchedLikeTelephone

    validates_with LegacyBulkLinearValidator, attributes: %i[is_legacy_bulk is_linear]

    scope :search_for_site_address_postcode, lambda { |term|
      joins(:addresses).merge(Address.search_for_postcode(term).site)
    }

    scope :search_for_contact_address_postcode, lambda { |term|
      joins(:addresses).merge(Address.search_for_postcode(term).contact)
    }

    scope :search_for_operator_address_postcode, lambda { |term|
      joins(:addresses).merge(Address.search_for_postcode(term).operator)
    }

    scope :search_for_person_name, lambda { |term|
      joins(:people).merge(Person.search_for_name(term))
    }

    scope :renewals, -> { where.not(referring_registration_id: nil) }

    scope :contact_email_present, -> { where.not(contact_email: nil) }

    scope :contact_phone_present, -> { where.not(contact_phone: nil) }

    scope :site_address_is_not_nccc, lambda {
      joins(:addresses).merge(Address.site.not_nccc)
    }

    scope :opted_in_to_renewal_emails, -> { where(reminder_opt_in: true) }

    # Override the base search scope to exclude placeholder registrations
    # (which don't exist for transient registrations)
    # Placeholder registrations are empty shells created for govpay reference purposes
    # and should not appear in search results
    scope :search_registration_and_relations, lambda { |term|
      base_search_registration_and_relations(term).where(placeholder: false)
    }

    def active?
      state == "active"
    end

    def expired?
      state == "expired"
    end

    def multisite?
      is_multisite_registration == true
    end

    def eligible_for_free_renewal?
      business_type == "charity" || registration_exemptions.includes([:exemption]).any? do |re|
        re.exemption.code == "T28"
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def state
      raise "A Registration must have at least one RegistrationExemption." if registration_exemptions.empty?

      return "active" if registration_exemptions.any?(&:active?)
      return "revoked" if registration_exemptions.any?(&:revoked?)
      return "expired" if registration_exemptions.any?(&:expired?)

      "ceased"
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def renewable?
      in_renewal_window? && in_renewable_state?
    end

    def in_renewable_state?
      active? || expired?
    end

    def valid_mobile_phone_number?
      record = clone
      DefraRuby::Validators::MobilePhoneNumberValidator.new(attributes: [:contact_phone]).validate(record)
      record.errors.empty?
    end
  end
end
