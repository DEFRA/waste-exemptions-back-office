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

  # https://eaflood.atlassian.net/browse/RUBY-2954
  desc "Fix incorrect template_label for first renewal reminder email"
  task fix_communication_log_first_renewal_template_label: :environment do
    WasteExemptionsEngine::CommunicationLog.where(
      template_id: "1ef273a9-b5e5-4a48-a343-cf6c774b8211",
      template_label: "Final renewal reminder email"
    ).update(template_label: "First renewal reminder email")
  end
end
