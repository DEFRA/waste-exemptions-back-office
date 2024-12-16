# frozen_string_literal: true

require "csv"

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-3448
  # https://eaflood.atlassian.net/browse/RUBY-3449
  desc "Change user roles"
  task change_user_roles: :environment do
    # role to change from => role to change to
    role_changes = {
      "data_agent" => "data_viewer",
      "admin_agent" => "customer_service_adviser",
      "system" => "admin_team_user"
    }

    role_changes.each do |role_from, role_to|
      User.where(role: role_from).find_each do |user|
        puts "Changing user role from #{role_from} to #{role_to} for user #{user.id}" unless Rails.env.test?
        user.update(role: role_to)
      end
    end
  end
end
