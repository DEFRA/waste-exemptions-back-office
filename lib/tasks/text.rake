# frozen_string_literal: true

namespace :text do
  namespace :renew_reminder do
    namespace :final do
      desc "Send final text reminder to all registrations expiring in X days (default is 7)"
      task send: :environment do
        return unless WasteExemptionsEngine::FeatureToggle.active?(:send_final_text_reminder)

        RenewalReminders::FinalRenewalReminderService.run
      end
    end
  end
end
