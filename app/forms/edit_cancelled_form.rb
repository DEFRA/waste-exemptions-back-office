# frozen_string_literal: true

require "waste_exemptions_engine/unsubmittable_form"

class EditCancelledForm < WasteExemptionsEngine::BaseForm
  # Override BaseForm method as users shouldn't be able to submit this form
  def submit(_params)
    raise WasteExemptionsEngine::UnsubmittableForm
  end
end
