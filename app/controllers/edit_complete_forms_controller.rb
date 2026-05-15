# frozen_string_literal: true

class EditCompleteFormsController < EditFormsBaseController
  helper ::EditHelper

  include WasteExemptionsEngine::CannotGoBackForm
  include WasteExemptionsEngine::CannotSubmitForm

  def new
    return unless super(EditCompleteForm, "edit_complete_form")

    EditCompletionService.run(edit_registration: @transient_registration)
  end
end
