# frozen_string_literal: true

require "notifications/client"

class NotifyRenewalLetterService < ::WasteExemptionsEngine::BaseService
  # So we can use displayable_address()
  include ::WasteExemptionsEngine::ApplicationHelper

  def run(registration:)
    @registration = NotifyRenewalLetterPresenter.new(registration)

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

    client.send_letter(template_id: template,
                       personalisation: personalisation)
  end

  private

  def template
    "931a9338-9177-4470-a51a-3a6991561863"
  end

  def personalisation
    {
      expiry_date: @registration.expiry_date,
      renewal_window_start_date: @registration.renewal_window_start_date,
      contact_name: @registration.contact_name,
      reference: @registration.reference,
      exemptions: @registration.exemptions_text,
      business_details: @registration.business_details_section
    }.merge(address_lines)
  end

  def address_lines
    address_values = [
      @registration.contact_name,
      displayable_address(@registration.contact_address)
    ].flatten

    address_hash = {}

    address_values.each_with_index do |value, index|
      line_number = index + 1
      address_hash["address_line_#{line_number}"] = value
    end

    address_hash
  end
end
