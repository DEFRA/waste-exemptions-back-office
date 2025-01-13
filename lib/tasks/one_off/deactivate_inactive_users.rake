# frozen_string_literal: true

namespace :one_off do
  desc "Deactivate inactive users"
  task :deactivate_inactive_users, [:dry_run] => :environment do |_task, args|
    users_to_deactivate = User.where.not(role: %w[system developer]).where(
      "last_sign_in_at < ? OR last_sign_in_at IS NULL", 3.months.ago
    )
    users_to_deactivate.each do |user|
      if args[:dry_run]
        puts "Currently in dry run mode. Would deactivate user #{user.email}"
      else
        puts "Deactivating user #{user.email}"
        user.update(active: false)
      end
    end
  end
end

# run with: bundle exec rake one_off:deactivate_inactive_users[dry_run]
