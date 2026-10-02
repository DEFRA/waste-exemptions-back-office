# frozen_string_literal: true

namespace :one_off do
  # Pass live-run to apply updates. Any other value, or no value, runs safely in dry-run mode.
  desc "Fix SV 00000 00000 site locations using postcode and UPRN"
  task :fix_sv_zero_grid_references, [:mode] => :environment do |_task, args|
    dry_run = args[:mode] != "live-run"

    FixSvZeroGridReferencesService.run(dry_run:)
  end
end
