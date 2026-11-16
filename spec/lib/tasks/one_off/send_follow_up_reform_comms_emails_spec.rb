# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:send_follow_up_reform_comms_emails", type: :rake do

  subject(:run_rake_task) { rake_task.invoke("live-run") }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:send_follow_up_reform_comms_emails"] }

  before { allow(SendFollowUpReformCommsEmailsService).to receive(:run).and_return(0) }

  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  it "sends the emails" do
    run_rake_task

    expect(SendFollowUpReformCommsEmailsService).to have_received(:run).with(dry_run: false)
  end

  context "when running in dry run mode (default)" do
    it "does not send the emails" do
      rake_task.invoke

      expect(SendFollowUpReformCommsEmailsService).to have_received(:run).with(dry_run: true)
    end
  end
end
