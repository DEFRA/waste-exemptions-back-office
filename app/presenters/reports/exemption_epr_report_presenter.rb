# frozen_string_literal: true

module Reports
  class ExemptionEprReportPresenter < BasePresenter

    delegate :code, to: :exemption, prefix: true

    def registration_number
      return registration.reference unless registration.multisite? && address.site_suffix.present?

      separator = ENV.fetch("REPORT_SITE_SUFFIX_SEPARATOR", "-")
      "#{registration.reference}#{separator}#{address.site_suffix}"
    end

    def organisation_name
      registration.operator_name
    end

    def organisation_premises
      registration.operator_address&.premises
    end

    def organisation_street_address
      registration.operator_address&.street_address
    end

    def organisation_locality
      registration.operator_address&.locality
    end

    def organisation_city
      registration.operator_address&.city
    end

    def organisation_postcode
      registration.operator_address&.postcode
    end

    def site_premises
      address&.premises
    end

    def site_street_address
      address&.street_address
    end

    def site_locality
      address&.locality
    end

    def site_city
      address&.city
    end

    def site_postcode
      address&.postcode
    end

    def site_country
      address&.country_iso
    end

    def site_ngr
      return nil if address&.postcode.present?

      address&.grid_reference
    end

    def site_easting
      address&.x
    end

    def site_northing
      address&.y
    end

    def ea_area_location
      address&.area
    end

    def exemption_registration_date
      registered_on.to_fs(:year_month_day)
    end

    def exemption_expiry_date
      expires_on.to_fs(:year_month_day)
    end

    def site_is_on_a_farm
      registration.on_a_farm ? "yes" : "no"
    end

    def user_is_a_farmer
      registration.is_a_farmer ? "yes" : "no"
    end
  end
end
