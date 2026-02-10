# frozen_string_literal: true

module Analytics
  class CrossCheckService < WasteExemptionsEngine::BaseService
    attr_reader :start_date, :end_date

    def run(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date

      {
        reg_total: reg_scope.count,
        reg_fo: reg_scope.where(assistance_mode: nil).count,
        reg_bo: reg_scope.where(assistance_mode: "full").count,
        analytics_total: analytics_scope.count,
        analytics_fo: analytics_scope.where(completed_route: "DIGITAL").count,
        analytics_bo: analytics_scope.where(completed_route: "ASSISTED_DIGITAL").count
      }
    end

    private

    def reg_scope
      @reg_scope ||= WasteExemptionsEngine::Registration.where(submitted_at: start_date..end_date)
    end

    def analytics_scope
      @analytics_scope ||= build_analytics_scope
    end

    def build_analytics_scope
      non_edit_types = %w[NewRegistration RenewingRegistration NewChargedRegistration]
      redirect_pages = %w[register_in_wales_form register_in_scotland_form register_in_northern_ireland_form]

      Analytics::UserJourney
        .only_types(non_edit_types)
        .where(completed_at: start_date.beginning_of_day..end_date.end_of_day)
        .where.not(
          id: Analytics::UserJourney
              .joins(:page_views)
              .where(<<~SQL.squish)
                analytics_page_views.id = (
                  SELECT id FROM analytics_page_views
                  WHERE analytics_page_views.user_journey_id = analytics_user_journeys.id
                  ORDER BY time DESC
                  LIMIT 1
                )
                AND analytics_page_views.page IN ('#{redirect_pages.join("', '")}')
              SQL
              .select(:id)
        )
    end
  end
end
