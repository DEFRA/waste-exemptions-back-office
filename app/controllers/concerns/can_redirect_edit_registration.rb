# frozen_string_literal: true

module CanRedirectEditRegistration
  # Persisted workflow states keep the legacy back_office names; BO app routes use shorter names.
  WORKFLOW_STATE_ROUTE_HELPERS = {
    "back_office_edit_form" => :new_edit_form_path,
    "back_office_edit_complete_form" => :new_edit_complete_form_path,
    "confirm_back_office_edit_cancelled_form" => :new_confirm_edit_cancelled_form_path,
    "back_office_edit_cancelled_form" => :new_edit_cancelled_form_path
  }.freeze

  def form_path
    return super unless @transient_registration.is_a?(WasteExemptionsEngine::BackOfficeEditRegistration)

    @transient_registration.save if @transient_registration.token.blank?

    helper_name = route_helper_for_workflow_state(@transient_registration.workflow_state)

    if main_app_route_helper?(helper_name)
      main_app.send(helper_name, token: @transient_registration.token)
    else
      WasteExemptionsEngine::Engine.routes.url_helpers.send(helper_name, token: @transient_registration.token)
    end
  end

  private

  def route_helper_for_workflow_state(workflow_state)
    WORKFLOW_STATE_ROUTE_HELPERS.fetch(workflow_state, :"new_#{workflow_state}_path")
  end

  def main_app_route_helper?(helper_name)
    Rails.application.routes.named_routes.helper_names.include?(helper_name.to_s)
  end
end
