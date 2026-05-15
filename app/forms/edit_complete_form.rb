# frozen_string_literal: true

require "waste_exemptions_engine/unsubmittable_form"

class EditCompleteForm < WasteExemptionsEngine::BaseForm
  delegate :reference, to: :transient_registration

  # Override BaseForm method as users shouldn't be able to submit this form
  def submit(_params)
    raise WasteExemptionsEngine::UnsubmittableForm
  end
end
