# frozen_string_literal: true

module CanRedirectEditRegistration
  def form_path
    return super unless @transient_registration.is_a?(EditRegistration)

    @transient_registration.save if @transient_registration.token.blank?

    helper_name = :"new_#{@transient_registration.workflow_state}_path"

    if main_app_route_helper?(helper_name)
      main_app.send(helper_name, token: @transient_registration.token)
    else
      WasteExemptionsEngine::Engine.routes.url_helpers.send(helper_name, token: @transient_registration.token)
    end
  end

  private

  def main_app_route_helper?(helper_name)
    Rails.application.routes.named_routes.helper_names.include?(helper_name.to_s)
  end
end
