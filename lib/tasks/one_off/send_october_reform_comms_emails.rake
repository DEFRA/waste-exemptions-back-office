# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-4440
  # rake one_off:send_october_reform_comms_emails[live-run] to send the emails,
  # otherwise runs in dry-run mode by default
  desc "Send the October reform comms email once to each unique contact email on an active registration"
  task :send_october_reform_comms_emails, [:mode] => [:environment] do |_task, args|
    dry_run = args[:mode] != "live-run"

    puts "[DRY RUN] No emails will be sent" if dry_run && !Rails.env.test?

    email_count = SendOctoberReformCommsEmailsService.run(dry_run: dry_run)
    puts "Reform comms emails #{dry_run ? 'to send' : 'sent'}: #{email_count}" unless Rails.env.test?
  end
end
