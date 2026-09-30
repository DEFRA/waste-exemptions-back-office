# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:fix_sv_zero_grid_references", type: :rake do
  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:fix_sv_zero_grid_references"] }

  before do
    allow(FixSvZeroGridReferencesService).to receive(:run)
  end

  after { rake_task.reenable }

  it "runs in dry-run mode by default" do
    rake_task.invoke

    expect(FixSvZeroGridReferencesService).to have_received(:run).with(dry_run: true)
  end

  it "requires an explicit live-run argument to update records" do
    rake_task.invoke("live-run")

    expect(FixSvZeroGridReferencesService).to have_received(:run).with(dry_run: false)
  end
end
