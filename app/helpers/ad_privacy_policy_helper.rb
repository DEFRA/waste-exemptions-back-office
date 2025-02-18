# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable
module AdPrivacyPolicyHelper
  def link_to_privacy_policy
    link_to(
      t(".privacy_notice_link_text"),
      URI.join(Rails.configuration.front_office_url, "/pages/privacy").to_s,
      target: "_blank", rel: "noopener"
    )
  end

  def destination_path
    if @registration.present?
      renew_path(reference: @registration.reference)
    elsif WasteExemptionsEngine::FeatureToggle.active?(:back_office_private_beta_link)
      transient_registration = WasteExemptionsEngine::NewChargedRegistration.create!
      WasteExemptionsEngine::Engine.routes.url_helpers.new_location_form_path(transient_registration.token)
    else
      WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path
    end
  end
end
# rubocop:enable Rails/HelperInstanceVariable
