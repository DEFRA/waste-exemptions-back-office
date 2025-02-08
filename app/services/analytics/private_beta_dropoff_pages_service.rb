# frozen_string_literal: true

module Analytics
  class PrivateBetaDropoffPagesService < WasteExemptionsEngine::BaseService

    attr_reader :start_date, :end_date

    def run(start_date:, end_date:)
      @start_date = start_date || default_start_date
      @end_date = end_date || Time.zone.today

      user_journeys_scope
        .map { |reg| reg.page_views.last.page.chomp("_form").dasherize }
        .tally
        .sort_by { |_k, v| v }
        .reverse
        .to_h
    end

    private

    def default_start_date
      Analytics::UserJourney.minimum_created_at&.to_date.presence || Time.zone.today
    end

    def abandoned_cutoff_time
      @abandoned_cutoff_time = Rails.application.config.user_journey_abandoned_days.days.ago
    end

    def user_journeys_scope
      UserJourney
        .only_types(["NewChargedRegistration"])
        .incomplete
        .date_range(start_date, end_date)
        .where(updated_at: ...abandoned_cutoff_time)
    end
  end
end
