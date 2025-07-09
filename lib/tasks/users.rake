# frozen_string_literal: true

namespace :users do
  desc "Deactivate inactive users"
  task :deactivate_inactive_users, [:dry_run] => :environment do |_task, args|
    dry_run = args[:dry_run].to_s.downcase == "dry_run"

    users_to_deactivate = User.where(active: true)
                              .where.not(role: %w[admin_team_user developer])
                              .where("last_sign_in_at < ? OR (last_sign_in_at IS NULL AND invitation_sent_at < ?)",
                                     3.months.ago, 3.months.ago)

    users_to_deactivate.each do |user|
      if dry_run
        puts "Currently in dry run mode. Would deactivate user #{user.email}" unless Rails.env.test?
      else
        puts "Deactivating user #{user.email}" unless Rails.env.test?
        user.update(active: false)
      end
    end
  end
end

# run with: bundle exec rake users:deactivate_inactive_users[dry_run]
