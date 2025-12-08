# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration_exemption")

module WasteExemptionsEngine
  class RegistrationExemption < WasteExemptionsEngine::ApplicationRecord
    self.table_name = "registration_exemptions"

    include CanDeactivateExemption

    scope :data_for_month, lambda { |first_day_of_the_month|
      registered_on_range = (first_day_of_the_month..first_day_of_the_month.end_of_month)

      where(registered_on: registered_on_range)
        .includes(:exemption)
        .includes(registration: :addresses)
        .order(:registered_on, :registration_id)
    }

    scope :not_expired, -> { where("expires_on >= CURRENT_DATE") }
    scope :expired_by_date, -> { where("expires_on < CURRENT_DATE") }

    scope :all_active_exemptions, lambda {
      active
        .not_expired
        .includes(:exemption)
        .includes(registration: :addresses)
        .order(:registered_on, :registration_id)
    }

    # This is called "renewal" rather than "renewal?" so that it can behave
    # like an attribute in the Boxi export service without any mapping logic.
    def renewal
      registration&.renewal?
    end

    def persist_version?
      # When the RE is ceased/revoked multiple saves happen, the first of which
      # is updating the deregistered_at timestamp. Since we only persist a
      # version on these 2 events and don't want to include this timestamp in
      # the version being persisted, we trigger the paper_trail hooks when this
      # timestamp is first updated.
      saved_change_to_deregistered_at?
    end

    def deregistered_by
      # Return the column value if present (new records)
      # Fall back to version lookup for historical records
      return self[:deregistered_by] if self[:deregistered_by].present?

      deregistration_version = versions.where(event: "update").last
      return if deregistration_version.blank?

      deregistration_version.whodunnit
    end

    def multisite?
      # For a multisite registration, registration_exemptions belong to the site address,
      # not to the registration.
      # We use this to establish whether this is a multi-site registration_exemption.
      return false if address.blank?

      # Check for edge cases where an address has a single registration_exemption
      address.registration_exemptions.many?
    end
  end
end
