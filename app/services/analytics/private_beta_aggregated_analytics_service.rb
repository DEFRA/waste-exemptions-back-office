# frozen_string_literal: true

module Analytics
  class PrivateBetaAggregatedAnalyticsService < AggregatedAnalyticsService

    private

    def journey_base_scope
      UserJourney.only_types(%w[
                               NewChargedRegistration
                             ]).date_range(start_date, end_date)
    end

  end
end
