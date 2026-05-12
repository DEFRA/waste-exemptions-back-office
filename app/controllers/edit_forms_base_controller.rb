# frozen_string_literal: true

class EditFormsBaseController < WasteExemptionsEngine::FormsController
  include EditPermissionChecks
  prepend CanRedirectEditRegistration

  private

  def find_or_initialize_registration(token)
    @transient_registration = EditRegistration.find_by(token: token)
    not_found if @transient_registration.blank?
  end

  def state_can_navigate_flexibly?(state)
    form_class_for_state(state).can_navigate_flexibly?
  end

  def form_class_for_state(state)
    Object.const_get(state.camelize)
  rescue NameError
    WasteExemptionsEngine.const_get(state.camelize)
  end
end
