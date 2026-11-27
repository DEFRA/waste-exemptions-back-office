# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:backfill_reform_comms_log_statuses", type: :rake do

  subject(:run_rake_task) { rake_task.invoke("live-run") }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:backfill_reform_comms_log_statuses"] }

  before { allow(BackfillReformCommsLogStatusesService).to receive(:run).and_return(0) }

  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  it "backfills the statuses" do
    run_rake_task

    expect(BackfillReformCommsLogStatusesService).to have_received(:run).with(dry_run: false)
  end

  context "when running in dry run mode (default)" do
    it "does not change the statuses" do
      rake_task.invoke

      expect(BackfillReformCommsLogStatusesService).to have_received(:run).with(dry_run: true)
    end
  end
end
