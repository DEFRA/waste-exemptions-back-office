# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-2852
  desc "Fix incorrect message_type and template_labels"
  task fix_communication_log_anomalies: :environment do

    WasteExemptionsEngine::CommunicationLog.where(
      template_id: "81cae4bd-9f4c-4e14-bf3c-44573cee4f5b",
      message_type: "email"
    ).update(message_type: "letter")

    WasteExemptionsEngine::CommunicationLog.where(
      template_id: "09320726-38c6-4989-a831-17c7d4ff37db",
      template_label: "Update your contact details and deregister your waste exemptions"
    ).update(template_label: "Registration edit link email")
  end
end
