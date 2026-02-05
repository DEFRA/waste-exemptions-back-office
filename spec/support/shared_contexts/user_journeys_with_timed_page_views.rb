# frozen_string_literal: true

RSpec.shared_context "with user journeys with timed page views" do

  before do
    # These should not be included:

    # Not a charged registration journey
    create(:user_journey, :registration,
           created_at:,
           page_views: [
             build(:page_view, page: "start_form", time: start_time + 2.seconds),
             build(:page_view, page: "location_form", time: start_time + 1.minute),
             build(:page_view, page: "operator_name_form", time: start_time + 3.hours),
             build(:page_view, page: "declaration_form", time: start_time + 4.days)
           ])
    # Not a charged registration journey
    create(:user_journey, :renewal,
           created_at:,
           page_views: [
             build(:page_view, page: "start_form", time: start_time + 5.seconds),
             build(:page_view, page: "location_form", time: start_time + 2.minutes),
             build(:page_view, page: "operator_name_form", time: start_time + 2.hours),
             build(:page_view, page: "declaration_form", time: start_time + 1.day)
           ])
    # Not within the date range
    create(:user_journey, :charged_registration,
           created_at: start_date - 1.day,
           page_views: [
             build(:page_view, page: "beta_start_form", time: start_time + 3.seconds),
             build(:page_view, page: "location_form", time: start_time + 3.minutes),
             build(:page_view, page: "operator_name_form", time: start_time + 1.hour),
             build(:page_view, page: "declaration_form", time: start_time + 2.days)
           ])
    # Not within the date range
    create(:user_journey, :charged_registration,
           created_at: end_date + 1.day,
           page_views: [
             build(:page_view, page: "beta_start_form", time: start_time + 3.seconds),
             build(:page_view, page: "location_form", time: start_time + 3.minutes),
             build(:page_view, page: "operator_name_form", time: start_time + 1.hour),
             build(:page_view, page: "declaration_form", time: start_time + 2.days)
           ])

    # Everything from here should be included
    create(:user_journey, :charged_registration, :completed_digital,
           created_at:,
           page_views: [
             build(:page_view, page: "beta_start_form", time: start_time + 3.seconds),
             build(:page_view, page: "location_form", time: start_time + 3.minutes),
             build(:page_view, page: "operator_name_form", time: start_time + 1.hour),
             build(:page_view, page: "declaration_form", time: start_time + 2.days)
           ])
    create(:user_journey, :charged_registration, :completed_digital,
           created_at:,
           page_views: [
             build(:page_view, page: "beta_start_form", time: start_time + 7.seconds),
             build(:page_view, page: "location_form", time: start_time + 18.minutes),
             build(:page_view, page: "operator_name_form", time: start_time + 4.days)
           ])
    create(:user_journey, :charged_registration, :completed_digital,
           created_at:,
           page_views: [
             build(:page_view, page: "beta_start_form", time: start_time + 6.seconds),
             build(:page_view, page: "operator_name_form", time: start_time + 7.minutes),
             build(:page_view, page: "declaration_form", time: start_time + 25.hours)
           ])
  end
end
