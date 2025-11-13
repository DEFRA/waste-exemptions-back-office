# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable
module DashboardsHelper
  LOCALE = "dashboards.helper"

  def preselect_registrations_radio_button?
    return true if @filter.blank?

    @filter == :registrations
  end

  def preselect_new_registrations_radio_button?
    @filter == :new_registrations
  end

  def status_tag_for(result)
    return :pending if result.is_a?(WasteExemptionsEngine::TransientRegistration)

    result.state
  end

  def result_name_for_visually_hidden_text(result)
    result.operator_name || result.reference || "new registration"
  end

  def label_for_business(registration)
    if registration.company_no_required?
      t("registered_name", scope: LOCALE)
    else
      t("operator_name", scope: LOCALE)
    end
  end

  def resource_heading_for(resource)
    registration_type = if resource.is_linear == true
                          "linear"
                        elsif resource.is_legacy_bulk == true || resource.is_multisite_registration == true
                          "multisite"
                        else
                          "regular"
                        end

    t(".heading.#{registration_type}", reference: resource.reference)
  end
end
# rubocop:enable Rails/HelperInstanceVariable
