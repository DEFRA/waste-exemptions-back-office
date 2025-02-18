# frozen_string_literal: true

require "notifications/client"

class FinalRenewalReminderTextService < RenewalReminderTextService
  private

  def template_label
    "Final renewal reminder text"
  end

  def template
    "7d101a7d-9678-464e-a57d-e18714afbc5d"
  end
end
