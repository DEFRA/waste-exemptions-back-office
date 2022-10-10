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
    else
      WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path
    end
  end
end
# rubocop:enable Rails/HelperInstanceVariable
