# frozen_string_literal: true

class EditFormsBaseController < WasteExemptionsEngine::FormsController
  include EditPermissionChecks

  # Persisted workflow states keep the legacy back_office names; BO app classes/controllers use shorter names.
  WORKFLOW_STATE_FORM_CLASSES = {
    "back_office_edit_form" => "EditForm",
    "back_office_edit_complete_form" => "EditCompleteForm",
    "confirm_back_office_edit_cancelled_form" => "ConfirmEditCancelledForm",
    "back_office_edit_cancelled_form" => "EditCancelledForm"
  }.freeze

  CONTROLLER_WORKFLOW_STATES = {
    "edit_forms" => "back_office_edit_form",
    "edit_complete_forms" => "back_office_edit_complete_form",
    "confirm_edit_cancelled_forms" => "confirm_back_office_edit_cancelled_form",
    "edit_cancelled_forms" => "back_office_edit_cancelled_form"
  }.freeze

  private

  def find_or_initialize_registration(token)
    @transient_registration = WasteExemptionsEngine::BackOfficeEditRegistration.find_by(token: token)
    not_found if @transient_registration.blank?
  end

  def state_can_navigate_flexibly?(state)
    form_class_for_state(state).can_navigate_flexibly?
  end

  def form_class_for_state(state)
    Object.const_get(WORKFLOW_STATE_FORM_CLASSES.fetch(state, state.camelize))
  rescue NameError
    WasteExemptionsEngine.const_get(state.camelize)
  end

  def form_matches_state?
    @transient_registration.workflow_state == requested_state
  end

  def requested_state
    CONTROLLER_WORKFLOW_STATES.fetch(controller_name, super)
  end
end
