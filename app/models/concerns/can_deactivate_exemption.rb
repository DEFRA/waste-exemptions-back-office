# frozen_string_literal: true

module CanDeactivateExemption
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :state do
      state :active
      state :ceased
      state :expired
      state :revoked

      event :cease do
        transitions from: :active,
                    to: :ceased,
                    after: :update_deregistered_at
      end

      event :revoke do
        transitions from: :active,
                    to: :revoked,
                    after: :update_deregistered_at
      end

      event :expire do
        transitions from: :active,
                    to: :expired
      end

      event :restore do
        transitions from: %i[ceased revoked], to: :active, after: :clear_deregistration_details
      end
    end
  end

  # Transition effects
  def update_deregistered_at
    self.deregistered_at = Time.zone.today
    save!
  end

  def clear_deregistration_details
    self.deregistered_at = nil
    self.deregistration_message = nil
    self.deregistered_by = nil
    save!
  end
end
