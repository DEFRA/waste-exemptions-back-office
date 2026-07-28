# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:cleanup_orphan_people", type: :rake do

  subject(:run_rake_task) { rake_task.invoke("live-run") }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:cleanup_orphan_people"] }

  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  context "when running in dry run mode (default)" do
    before do
      create(:person, registration_id: nil)
    end

    it "does not delete any people" do
      expect do
        rake_task.invoke
      end.not_to change { WasteExemptionsEngine::Person.where(registration_id: nil).count }
    end
  end

  context "when there are orphan people with no registration" do
    before do
      create(:person, registration_id: nil)
      create(:person, registration_id: nil)
    end

    it "deletes the orphan people" do
      expect { run_rake_task }.to change {
        WasteExemptionsEngine::Person.where(registration_id: nil).count
      }.by(-2)
    end
  end

  context "when people are associated with a registration" do
    before do
      create(:person, registration: create(:registration))
    end

    it "does not delete them" do
      expect { run_rake_task }.not_to change {
        WasteExemptionsEngine::Person.where.not(registration_id: nil).count
      }
    end
  end
end
