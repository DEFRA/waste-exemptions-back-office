# frozen_string_literal: true

module Reports
  class ExemptionEprReportPresenter < BasePresenter

    delegate :code, to: :exemption, prefix: true

    # The presenter operates at the registration_exemption level but uses many attributes of the owning registration.
    # Multisite registration_exemptions have an indirect association with the registration.
    def owning_registration
      @owning_registration ||= multisite? ? address.registration : registration
    end

    def registration_number
      return owning_registration.reference unless multisite? && address.site_suffix.present?

      separator = ENV.fetch("REPORT_SITE_SUFFIX_SEPARATOR", "-")
      "#{owning_registration.reference}#{separator}#{address.site_suffix}"
    end

    def organisation_name
      owning_registration.operator_name
    end

    def organisation_premises
      owning_registration.operator_address&.premises
    end

    def organisation_street_address
      owning_registration.operator_address&.street_address
    end

    def organisation_locality
      owning_registration.operator_address&.locality
    end

    def organisation_city
      owning_registration.operator_address&.city
    end

    def organisation_postcode
      owning_registration.operator_address&.postcode
    end

    def site_premises
      owning_registration.site_address&.premises
    end

    def site_street_address
      owning_registration.site_address&.street_address
    end

    def site_locality
      owning_registration.site_address&.locality
    end

    def site_city
      owning_registration.site_address&.city
    end

    def site_postcode
      owning_registration.site_address&.postcode
    end

    def site_country
      owning_registration.site_address&.country_iso
    end

    def site_ngr
      return nil if owning_registration.site_address&.postcode.present?

      owning_registration.site_address&.grid_reference
    end

    def site_easting
      owning_registration.site_address&.x
    end

    def site_northing
      owning_registration.site_address&.y
    end

    def ea_area_location
      owning_registration.site_address&.area
    end

    def exemption_registration_date
      registered_on.to_fs(:year_month_day)
    end

    def exemption_expiry_date
      expires_on.to_fs(:year_month_day)
    end

    def site_is_on_a_farm
      owning_registration.on_a_farm ? "yes" : "no"
    end

    def user_is_a_farmer
      owning_registration.is_a_farmer ? "yes" : "no"
    end
  end
end
