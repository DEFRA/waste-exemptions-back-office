# frozen_string_literal: true

namespace :lookups do
  namespace :update do
    desc "Check and update EA areas for active registration sites."
    task ea_area: :environment do
      CheckEaAreaService.run(
        batch_size: ENV.fetch("EA_AREA_BATCH_SIZE", CheckEaAreaService::DEFAULT_BATCH_SIZE).to_i,
        logger: Logger.new($stdout)
      )
    end
  end
end
