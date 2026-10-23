# frozen_string_literal: true

class EditCompleteFormsController < EditFormsBaseController
  helper ::EditHelper

  include WasteExemptionsEngine::CannotGoBackForm
  include WasteExemptionsEngine::CannotSubmitForm

  def new
    return unless super(EditCompleteForm, "edit_complete_form")

    EditCompletionService.run(edit_registration: @transient_registration)
  rescue ActionController::RoutingError
    raise
  rescue StandardError => e
    flash[:error] = "Edit could not be completed: #{e.message}"
    redirect_to registration_path(@transient_registration.reference)
  end
end
