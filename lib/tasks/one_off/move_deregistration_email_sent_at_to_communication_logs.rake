# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-2481
  desc "Move registration deregistration_email_sent_at details to a registration communication_log"
  task :move_deregistration_email_sent_at_to_communication_logs, [:batch_limit] => [:environment] do |_task, args|

    batch_limit = (args[:batch_limit] || 10_000).to_i

    registrations = WasteExemptionsEngine::Registration
                    .where.not(deregistration_email_sent_at: nil)
                    .limit(batch_limit)

    puts "Processing #{registrations.count} registrations" unless Rails.env.test?

    registrations.each do |registration|

      # within a transaction because we don't want to delete the data if the copy fails
      registration.transaction do

        # add a communication_log with the value of the deregistration_email_sent_at attribute
        registration.communication_logs << WasteExemptionsEngine::CommunicationLog.new(
          message_type: "email",
          template_id: "9148895b-e239-4118-8ffd-dadd9b2cf462",
          template_label: "Deregistration confirmation email",
          # we can't be sure whether the email was sent to the contact email, applicant email or both, so leave nil
          sent_to: nil
        )

        # Clear the deregistration_email_sent_at value
        registration.update(deregistration_email_sent_at: nil)
      end
    end
  end
end
