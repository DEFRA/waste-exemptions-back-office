# frozen_string_literal: true

require "notifications/client"

module RenewalReminders

  class FinalRenewalReminderTextService < RenewalReminderTextServiceBase
    private

    def template_label
      "Final renewal reminder text"
    end

    def template
      Templates::FINAL_RENEWAL_REMINDER_TEXT
    end
  end
end
