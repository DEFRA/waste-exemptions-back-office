# frozen_string_literal: true

class ReasonForChangeForm < WasteExemptionsEngine::BaseForm
  delegate :reason_for_change, to: :transient_registration

  validates :reason_for_change, presence: true, length: { maximum: 500 }

  def self.can_navigate_flexibly?
    false
  end
end
