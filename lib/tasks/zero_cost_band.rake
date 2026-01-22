# frozen_string_literal: true

namespace :bands do
  desc "Create the zero compliance cost band (band 0) for exemptions like T28"
  task create_zero_cost_band: :environment do
    ZeroCostBandService.run
  end

  desc "Assign T28 exemption to the zero compliance cost band"
  task assign_t28_to_zero_cost_band: :environment do
    result = ZeroCostBandService.new.assign_exemption("T28")
    exit 1 unless result
  end

  desc "Create zero compliance cost band and assign T28 to it"
  task setup_zero_cost_band: :environment do
    Rake::Task["bands:create_zero_cost_band"].invoke
    Rake::Task["bands:assign_t28_to_zero_cost_band"].invoke
  end
end
