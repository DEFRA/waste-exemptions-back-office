# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-3041
  desc "Fix user journeys incorrectly marked as incomplete"
  task fix_incomplete_user_journeys: :environment do
    incomplete_journeys = WasteExemptionsEngine::Analytics::UserJourney
                          .where(completed_route: nil)
                          .includes(:page_views)

    completed_count = 0

    incomplete_journeys.find_each do |journey|
      completion_page_view = journey.page_views.find do |pv|
        WasteExemptionsEngine::Analytics::UserJourney::COMPLETION_PAGES.include?(pv.page)
      end

      next unless completion_page_view

      journey.update(
        completed_at: completion_page_view.time || Time.zone.now,
        completed_route: completion_page_view.route
      )
      completed_count += 1
      puts "Completed journey #{journey.id}" unless Rails.env.test?
    end

    puts "Total journeys completed: #{completed_count}" unless Rails.env.test?
  end
end
