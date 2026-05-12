# frozen_string_literal: true

class EditCancelledFormsController < EditFormsBaseController
  helper ::EditHelper

  include WasteExemptionsEngine::CannotGoBackForm
  include WasteExemptionsEngine::CannotSubmitForm

  def new
    return unless super(EditCancelledForm, "edit_cancelled_form")

    EditCancellationService.run(edit_registration: @transient_registration)
  end
end
