# frozen_string_literal: true

require "notifications/client"

class RenewalReminderService < WasteExemptionsEngine::BaseService
  # So we can use displayable_address()
  include WasteExemptionsEngine::ApplicationHelper

  protected

  def template
    raise NotImplementedError
  end

  def personalisation
    {
      contact_name: contact_name,
      exemptions: exemptions,
      expiry_date: expiry_date,
      magic_link_url: magic_link_url,
      reference: @registration.reference,
      site_location: site_location,
      unsubscribe_link: unsubscribe_link
    }
  end

  def contact_name
    "#{@registration.contact_first_name} #{@registration.contact_last_name}"
  end

  def exemptions
    relevant_exemptions = @registration.registration_exemptions.order(:exemption_id).select do |re|
      re.may_expire? || re.expired?
    end
    relevant_exemptions.map { |ex| "#{ex.exemption.code} #{ex.exemption.summary}" }
  end

  def expiry_date
    # Currently you can only add exemptions when you register, so we can assume they expire at the same time
    @registration.registration_exemptions.first.expires_on.to_fs(:day_month_year)
  end

  def magic_link_url
    Rails.configuration.front_office_url +
      WasteExemptionsEngine::Engine.routes.url_helpers.renew_path(token: magic_link_token)
  end

  def magic_link_token
    @registration.regenerate_renew_token if @registration.renew_token.nil?
    @registration.renew_token
  end

  def site_location
    address = @registration.site_address

    if address.located_by_grid_reference?
      address.grid_reference
    else
      displayable_address(address).join(", ")
    end
  end

  def unsubscribe_link
    WasteExemptionsEngine::UnsubscribeLinkService.run(registration: @registration)
  end

  def message_type
    raise NotImplementedError
  end

  def create_beta_participant_log(registration:)
    registration.communication_logs.create(
      message_type: message_type,
      template_id: nil,
      template_label: "Beta participant - No renewal reminder sent",
      sent_to: registration.send(sent_to_method)
    )
  end
end
