# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-3041
  desc "Fix user journeys incorrectly marked as incomplete"
  task fix_incomplete_user_journeys: :environment do
    incomplete_journeys = WasteExemptionsEngine::Analytics::UserJourney.where(completed_route: nil)
    incomplete_journeys.each do |journey|
      # check if journey passed the completion route
      journey.page_views.each do |page_view|
        page = page_view.page
        next unless WasteExemptionsEngine::Analytics::UserJourney::COMPLETION_PAGES.include?(page)

        # complete the journey
        journey.update(
          completed_at: Time.zone.now,
          completed_route: page_view.route
        )
        puts "completed journey #{journey.id}" unless Rails.env.test?
        break 1 # exit the first loop
      end
    end
  end
end
