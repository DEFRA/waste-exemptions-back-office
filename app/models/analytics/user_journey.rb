# frozen_string_literal: true

module Analytics
  class UserJourney < WasteExemptionsEngine::Analytics::UserJourney

    # These scopes and helpers are used only for presentation of aggregate stats in the back-office.

    START_CUTOFF_PAGES = %w[
      location_form
      edit_exemptions_form
      front_office_edit_form
      confirm_renewal_form
      renew_without_changes_form
    ].freeze

    scope :registrations, -> { where(journey_type: "NewRegistration") }
    scope :charged_registrations, -> { where(journey_type: "NewChargedRegistration") }
    scope :renewals, -> { where(journey_type: "RenewingRegistration") }
    scope :only_types, ->(journey_types) { where(journey_type: journey_types) }
    scope :started_digital, -> { where(started_route: "DIGITAL") }
    scope :started_assisted_digital, -> { where(started_route: "ASSISTED_DIGITAL") }
    scope :incomplete, -> { where(completed_at: nil) }
    scope :completed, -> { where.not(completed_at: nil) }
    scope :completed_digital, -> { where(completed_route: "DIGITAL") }
    scope :completed_assisted_digital, -> { where(completed_route: "ASSISTED_DIGITAL") }

    # rubocop:disable Metrics/BlockLength
    scope :passed_start_cutoff_page, lambda {
      # Subquery to check for the existence of the START_CUTOFF_PAGES in any PageView for the UserJourney
      start_cutoff_page_subquery = <<-SQL.squish
          EXISTS (
            SELECT 1
            FROM analytics_page_views
            WHERE
              analytics_page_views.user_journey_id = analytics_user_journeys.id
              AND analytics_page_views.page IN ('#{START_CUTOFF_PAGES.join("', '")}')
          )
      SQL

      # Subquery to find the last PageView for each UserJourney
      last_page_not_cutoff_subquery = <<-SQL.squish
          NOT EXISTS (
            SELECT 1
            FROM analytics_page_views as last_pages
            WHERE
              last_pages.user_journey_id = analytics_user_journeys.id
              AND last_pages.id = (
                SELECT id
                FROM analytics_page_views
                WHERE analytics_page_views.user_journey_id = last_pages.user_journey_id
                ORDER BY created_at DESC
                LIMIT 1
              )
              AND last_pages.page IN ('#{START_CUTOFF_PAGES.join("', '")}')
          )
      SQL

      where(start_cutoff_page_subquery).where(last_page_not_cutoff_subquery)
    }
    # rubocop:enable Metrics/BlockLength

    scope :date_range, lambda { |start_date, end_date|
      where(created_at: start_date.beginning_of_day..end_date.end_of_day)
        .or(
          # Specify the table name in the last clause to disambiguate 'created_at' when used with a join
          where(
            "completed_at IS NOT NULL AND " \
            "completed_at >= :start AND " \
            "completed_at <= :end AND " \
            "analytics_user_journeys.created_at >= :start",
            start: start_date.beginning_of_day, end: end_date.end_of_day
          )
        )
    }

    def self.minimum_created_at
      minimum(:created_at)
    end

    def self.average_duration(user_journey_scope)
      durations = user_journey_scope.pluck(Arel.sql("EXTRACT(EPOCH FROM (updated_at - created_at))"))
      return 0 if durations.empty?

      durations.sum / durations.size
    end
  end
end
