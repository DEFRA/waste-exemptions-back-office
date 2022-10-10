# frozen_string_literal: true

module ActionLinksHelper
  def view_link_for(resource)
    case resource
    when WasteExemptionsEngine::Registration
      registration_path(resource.reference)
    when WasteExemptionsEngine::NewRegistration
      new_registration_path(resource.id)
    else
      "#"
    end
  end

  def resume_link_for(resource)
    return "#" unless resource.is_a?(WasteExemptionsEngine::NewRegistration)

    # If the assistance_mode is nil, the registration was started in the front-office
    resource.update(assistance_mode: "partial") if resource.assistance_mode.blank?

    token = resource.token
    path = "new_#{resource.workflow_state}_path".to_sym
    WasteExemptionsEngine::Engine.routes.url_helpers.public_send(path, token)
  end

  def edit_link_for(resource)
    return "#" unless resource.is_a?(WasteExemptionsEngine::Registration)

    WasteExemptionsEngine::Engine.routes.url_helpers.new_edit_form_path(resource.reference)
  end

  def display_resume_link_for?(resource)
    return false unless resource.is_a?(WasteExemptionsEngine::NewRegistration)

    can?(:update, resource)
  end

  def display_edit_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:update, resource)
  end

  def display_deregister_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:deregister, resource)
  end

  def display_confirmation_letter_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && resource.active?
  end

  def display_renew_links_for?(resource)
    can?(:renew, resource) &&
      resource.renewable?
  end

  def display_renew_window_closed_text_for?(resource)
    can?(:renew, resource) &&
      resource.in_renewable_state? &&
      resource.past_renewal_window?
  end

  def display_already_renewed_text_for?(resource)
    can?(:renew, resource) &&
      resource.in_renewal_window? &&
      resource.already_renewed?
  end

  def display_refresh_registered_company_name_link_for?(resource)
    return false unless display_edit_link_for?(resource)

    resource.active? && resource.company_no_required?
  end
end
