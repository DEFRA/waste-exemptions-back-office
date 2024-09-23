# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bulk seed registrations", type: :rake do
  include_context "rake"

  describe "bulk_seed_registration_exemptions" do
    after do
      Rake::Task["bulk_seed_registration_exemptions"].reenable
    end

    it "runs without error" do
      expect do
        Rake::Task["bulk_seed_registration_exemptions"].invoke(3)
      end.not_to raise_error
    end
  end

  describe "benchmark_search" do

    original_stdout = $stdout

    before do
      # suppress noisy outputs during unit test
      $stdout = StringIO.new
    end

    after do
      $stdout = original_stdout
      Rake::Task["benchmark_search"].reenable
    end

    it "runs without error" do
      expect do
        Rake::Task["benchmark_search"].invoke("a")
      end.not_to raise_error
    end
  end
end
