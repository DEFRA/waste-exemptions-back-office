# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExpectOutput
RSpec.describe "analytics:cross_check", type: :rake do
  include_context "rake"

  original_stdout = $stdout # rubocop:disable RSpec/LeakyLocalVariable

  let(:start_date) { 90.days.ago.strftime("%Y-%m-%d") }
  let(:end_date) { Time.zone.today.strftime("%Y-%m-%d") }
  let(:task) { Rake::Task["analytics:cross_check"] }
  let(:counts) do
    { reg_total: 5, reg_fo: 3, reg_bo: 2, analytics_total: 5, analytics_fo: 3, analytics_bo: 2 }
  end

  before do
    $stdout = StringIO.new
    allow(Analytics::CrossCheckService).to receive(:run).and_return(counts)
    task.reenable
  end

  after do
    $stdout = original_stdout
  end

  it "runs without error" do
    expect { task.invoke(start_date, end_date) }.not_to raise_error
  end

  it "calls CrossCheckService with parsed dates" do
    task.invoke(start_date, end_date)

    expect(Analytics::CrossCheckService).to have_received(:run).with(
      start_date: Date.parse(start_date),
      end_date: Date.parse(end_date)
    )
  end

  context "when dates are not provided" do
    it "prints usage and exits" do
      expect { task.invoke }.to raise_error(SystemExit)
    end
  end
end
# rubocop:enable RSpec/ExpectOutput
