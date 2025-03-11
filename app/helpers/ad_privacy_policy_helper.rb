# frozen_string_literal: true

module AdPrivacyPolicyHelper
  def link_to_privacy_policy
    link_to(
      t(".privacy_notice_link_text"),
      URI.join(Rails.configuration.front_office_url, "/pages/privacy").to_s,
      target: "_blank", rel: "noopener"
    )
  end

  def destination_path(registration = nil)
    if registration.present?
      renew_path(reference: registration.reference)
    else
      transient_registration = WasteExemptionsEngine::NewChargedRegistration.create!
      WasteExemptionsEngine::Engine.routes.url_helpers.new_location_form_path(transient_registration.token)
    end
  end
end
