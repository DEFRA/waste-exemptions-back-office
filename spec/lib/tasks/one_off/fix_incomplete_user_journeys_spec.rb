# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:fix_incomplete_user_journeys", type: :rake do

  subject(:run_rake_task) { rake_task.invoke }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:fix_incomplete_user_journeys"] }

  let(:pages_incomplete_journey) { %w[start_form location_form registration_number_form] }
  let(:pages_complete_journey) { %w[start_form location_form registration_number_form registration_complete_form] }

  let(:incomplete_journey) { create(:user_journey, :started_digital, completed_route: nil, visited_pages: pages_incomplete_journey) }
  let(:journey_completed_and_marked_as_complete) { create(:user_journey, :started_digital, :completed_assisted_digital, visited_pages: pages_complete_journey) }
  let(:journey_completed_and_marked_as_incomplete) { create(:user_journey, :started_digital, completed_route: nil, visited_pages: pages_complete_journey) }

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  it { expect { run_rake_task }.to change { journey_completed_and_marked_as_incomplete.reload.completed_route }.to "DIGITAL" }
  it { expect { run_rake_task }.not_to change { journey_completed_and_marked_as_complete.reload.completed_route } }
  it { expect { run_rake_task }.not_to change { incomplete_journey.reload.completed_route } }
end
