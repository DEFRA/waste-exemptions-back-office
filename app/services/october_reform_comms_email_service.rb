# frozen_string_literal: true

require "notifications/client"

class OctoberReformCommsEmailService < ReformCommsEmailService
  TEMPLATE_ID = "41977e01-54f0-485d-a531-dd8c937eccb5"
  TEMPLATE_LABEL = "Reform comms email - October 2026"

  private

  def notify_client
    Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)
  end
end
