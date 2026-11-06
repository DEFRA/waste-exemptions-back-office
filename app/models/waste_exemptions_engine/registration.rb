# frozen_string_literal: true

load WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration.rb")

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

    scope :contact_email_present, -> { where.not(contact_email: [nil, ""]) }

    scope :contact_email_not_present, -> { where(contact_email: [nil, ""]) }

    scope :with_current_exemptions, lambda {
      where(id: RegistrationExemption.current.select(:registration_id))
    }

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

    scope :linear, -> { where(is_linear: true) }

    PERMIT_APPLICATION_STATUSES = %w[
      not_assigned
      assigned_to_po
      returned_not_duly_made
      duly_made
      issued
      refused
    ].freeze

    scope :permit_application_in_progress, -> { where.not(permit_application_status: nil) }

    def active?
      state == "active"
    end

    def expired?
      state == "expired"
    end

    def linear?
      is_linear == true
    end

    def permit_application_in_progress?
      permit_application_status.present?
    end

    # rubocop:disable-next Metrics/CyclomaticComplexity
    def state
      raise "A Registration must have at least one RegistrationExemption." if registration_exemptions.empty?

      return "active" if registration_exemptions.any?(&:active?)
      return "revoked" if registration_exemptions.any?(&:revoked?)
      return "expired" if registration_exemptions.any?(&:expired?)

      "ceased"
    end

    def restorable?
      %w[ceased revoked].include?(state)
    end

    # True when the exemptions were deregistered on more than one date, so they
    # were not all deregistered together and have to be restored one at a time.
    def previously_deregistered_exemptions?
      registration_exemptions.deregistered.map(&:deregistered_at).uniq.many?
    end

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
