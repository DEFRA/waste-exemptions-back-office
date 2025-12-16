# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Benchmark search task", type: :rake do
  include_context "rake"

  # rubocop:disable RSpec/ExpectOutput
  describe "benchmark_search" do

    original_stdout = $stdout # rubocop:disable RSpec/LeakyLocalVariable

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
  # rubocop:enable RSpec/ExpectOutput
end
