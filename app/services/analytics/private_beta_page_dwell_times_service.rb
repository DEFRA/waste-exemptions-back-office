# frozen_string_literal: true

module Analytics
  class PrivateBetaPageDwellTimesService < WasteExemptionsEngine::BaseService

    attr_accessor :start_date, :end_date, :page_dwell_times, :page_dwell_counts

    def run(start_date:, end_date:)
      @start_date = start_date || default_start_date
      @end_date = end_date || Time.zone.today

      dwell_times
        .transform_keys { |page| page.chomp("_form").dasherize }
        .sort_by { |_k, v| v }
        .reverse
        .to_h
    end

    private

    def default_start_date
      Analytics::UserJourney.minimum_created_at&.to_date.presence || Time.zone.today
    end

    # Aggregate dwell time per page
    def dwell_times
      # Bullet complains about unused eager loading but if its recommendation
      # to add .includes([:page_views]) is followed the uj's page_views are truncated.
      # So we disable bullet for this block.
      bullet_enabled_previous_value = Bullet.enable?
      Bullet.enable = false

      # user_journeys_scope.includes([:page_views]).each do |uj|
      user_journeys_scope.each do |uj|

        sorted_page_views = uj.page_views.sort_by(&:time)

        # Exclude the last page_view as we don't have page dwell information for it
        (0..sorted_page_views.length - 2).each do |page_view_index|
          timed_page_view = sorted_page_views[page_view_index]
          next_page_view = sorted_page_views[page_view_index + 1]

          tally_counts_and_times(timed_page_view, next_page_view)
        end
      end

      average_page_dwell_times
    ensure
      Bullet.enable = bullet_enabled_previous_value
    end

    def tally_counts_and_times(timed_page_view, next_page_view)
      @page_dwell_times ||= {}
      @page_dwell_counts ||= {}

      page_dwell_counts[timed_page_view.page] ||= 0
      page_dwell_counts[timed_page_view.page] += 1

      page_dwell_times[timed_page_view.page] ||= 0
      page_dwell_times[timed_page_view.page] += (next_page_view.time - timed_page_view.time).seconds
    end

    def average_page_dwell_times
      page_dwell_counts.to_h do |page, _count|
        next if page_dwell_counts[page].blank? || page_dwell_times[page].blank?

        [page, (page_dwell_times[page] / page_dwell_counts[page]).round]
      end
    end

    def user_journeys_scope
      # All user journeys in the date range which include a page_view for the beta-start page
      UserJourney.date_range(start_date, end_date)
                 .joins(:page_views)
                 .where(page_views: { page: "beta_start_form" })
    end
  end
end
