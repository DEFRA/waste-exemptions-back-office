# frozen_string_literal: true

module ActionLinksHelper
  def view_link_for(resource)
    case resource
    when WasteExemptionsEngine::Registration
      registration_path(resource.reference)
    when WasteExemptionsEngine::NewRegistration, WasteExemptionsEngine::NewChargedRegistration
      new_registration_path(resource.id)
    else
      "#"
    end
  end

  def resume_link_for(resource)
    return "#" unless new_or_new_charged_registration(resource)

    # If the assistance_mode is nil, the registration was started in the front-office
    resource.update(assistance_mode: "partial") if resource.assistance_mode.blank?

    token = resource.token
    path = :"new_#{resource.workflow_state}_path"
    WasteExemptionsEngine::Engine.routes.url_helpers.public_send(path, token)
  end

  def edit_link_for(resource)
    return "#" unless resource.is_a?(WasteExemptionsEngine::Registration)

    WasteExemptionsEngine::Engine.routes.url_helpers.new_back_office_edit_form_path(resource.reference)
  end

  def edit_expiry_date_link_for(resource)
    return "#" unless resource.is_a?(WasteExemptionsEngine::Registration)

    Rails.application.routes.url_helpers.modify_expiry_date_form_path(resource.reference)
  end

  def reset_transient_registrations_link_for(resource)
    return "#" unless resource.is_a?(WasteExemptionsEngine::Registration)

    Rails.application.routes.url_helpers.reset_transient_registrations_path(resource.reference)
  end

  def display_resume_link_for?(resource)
    return false unless new_or_new_charged_registration(resource)

    can?(:update, resource)
  end

  def display_edit_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:update, resource)
  end

  def display_edit_expiry_date_link_for?(resource)
    return false unless resource.is_a?(WasteExemptionsEngine::Registration)

    return false unless %w[active expired].include?(resource.state)

    can?(:update_expiry_date, resource)
  end

  def display_deregister_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:deregister, resource)
  end

  def display_send_edit_invite_email_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) &&
      can?(:send_comms, resource) &&
      resource.active?
  end

  def display_certificate_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && resource.active?
  end

  def display_confirmation_communication_links_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) &&
      can?(:send_comms, resource) &&
      resource.active?
  end

  def display_renew_links_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) &&
      can?(:renew, resource) &&
      resource.renewable?
  end

  def display_renew_window_closed_text_for?(resource)
    resource.present? &&
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

  def display_communication_logs_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:read, resource)
  end

  def display_reset_transient_registrations_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:reset_transient_registrations, resource)
  end

  def display_payment_details_link_for?(resource)
    resource.is_a?(WasteExemptionsEngine::Registration) && can?(:read, resource) && resource.account.present?
  end

  def can_display_refund_link?(resource)
    resource.account.overpaid? && resource.account.payments.refundable.any?
  end

  def can_display_reversal_link?(resource)
    resource
      .account
      .payments
      .reverseable.any?
  end

  private

  def new_or_new_charged_registration(resource)
    resource.is_a?(WasteExemptionsEngine::NewRegistration) ||
      resource.is_a?(WasteExemptionsEngine::NewChargedRegistration)
  end
end
