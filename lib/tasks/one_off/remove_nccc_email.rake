# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-1997
  desc "Remove NCCC email"
  task remove_nccc_email: :environment do
    RemoveNcccEmailService.run
  end
end