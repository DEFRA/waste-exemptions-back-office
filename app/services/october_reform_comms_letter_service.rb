# frozen_string_literal: true

require "notifications/client"

class OctoberReformCommsLetterService < ReformCommsLetterService
  TEMPLATE_ID = "cdbd027b-aa13-49f2-b904-0fe9ec636958"
  TEMPLATE_LABEL = "Reform comms letter - October 2026"

  private

  def notify_client
    Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)
  end
end
