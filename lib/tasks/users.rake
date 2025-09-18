# frozen_string_literal: true

namespace :users do
  desc "Deactivate inactive users"
  task :deactivate_inactive_users, [:dry_run] => :environment do |_task, args|
    # run with: bundle exec rake users:deactivate_inactive_users[dry_run]
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

  desc "Fix signed in accounts with expired invitations"
  task fix_signed_in_accounts_with_expired_invitations: :environment do
    find_users_with_expired_invitations.each do |user|
      clear_invitation_token(user)
    end
  end
end

def find_users_with_expired_invitations
  User.where(
    "active=? AND sign_in_count>? AND invitation_accepted_at IS NULL AND invitation_sent_at < ?",
    true, 0, User.invite_for.ago
  )
end

def clear_invitation_token(user)
  puts "Clearing invitation for user #{user.email}" unless Rails.env.test?
  user.invitation_token = nil
  user.invitation_created_at = nil
  user.invitation_sent_at = nil
  user.save!
end
