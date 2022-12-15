# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "registration_exemption")

module WasteExemptionsEngine
  class RegistrationExemption < ::WasteExemptionsEngine::ApplicationRecord
    self.table_name = "registration_exemptions"

    has_paper_trail if: proc { |re| re.persist_version? }

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
  end
end
