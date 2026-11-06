# frozen_string_literal: true

class RestorationsPresenter

  attr_reader :registration_reference, :heading, :exemption_description, :site, :form_path, :back_path

  def initialize(resource)
    @type = resource.class.to_s.split("::").last
    @registration_reference = registration? ? resource.reference : resource.registration.reference
    @heading = heading_text
    @exemption_description = exemption_description_text(resource)
    @site = site_for(resource)
    @form_path = lookup_form_path(resource)
    @back_path = Rails.application.routes.url_helpers.registration_path(reference: registration_reference)
  end

  private

  def registration?
    @type == "Registration"
  end

  def heading_text
    if registration?
      I18n.t("restore_exemptions.new.registration_heading", registration_reference: registration_reference)
    else
      I18n.t("restore_exemptions.new.exemption_heading")
    end
  end

  def exemption_description_text(resource)
    return if registration?

    "#{resource.exemption.code}: #{resource.exemption.summary}"
  end

  def site_for(resource)
    return resource.site_address if registration?

    resource.address || resource.registration.site_address
  end

  def lookup_form_path(resource)
    if registration?
      Rails.application.routes.url_helpers.restore_registrations_path(resource.id)
    else
      Rails.application.routes.url_helpers.restore_exemptions_path(resource.id)
    end
  end
end
