# frozen_string_literal: true

module Reports
  class RegistrationDeregistrationEmailPresenter < BasePresenter
    # So we can use displayable_address()
    include WasteExemptionsEngine::ApplicationHelper

    def contact_name
      "#{contact_first_name} #{contact_last_name}"
    end

    def magic_link_url
      Rails.configuration.front_office_url +
        WasteExemptionsEngine::Engine.routes.url_helpers.renew_path(token: magic_link_token)
    end

    def site_details
      address = site_address

      if site_address.located_by_grid_reference?
        site_address.grid_reference
      else
        displayable_address(address).join(", ")
      end
    end

    def exemption_details
      relevant_exemptions = registration_exemptions.order(:exemption_id).select do |re|
        re.may_expire? || re.expired?
      end

      relevant_exemptions.map { |ex| "#{ex.exemption.code} #{ex.exemption.summary}" }.join(", ")
    end

    private

    def magic_link_token
      regenerate_renew_token if renew_token.nil?
      renew_token
    end
  end
end
