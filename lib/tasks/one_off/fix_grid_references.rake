# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-1932
  desc "Fix grid references"
  task fix_grid_references: :environment do
    FixGridReferencesService.run
  end
end
