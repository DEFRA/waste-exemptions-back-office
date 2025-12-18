# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/ExpectOutput
RSpec.describe "test:magic_link", type: :rake do
  include_context "rake"

  original_stdout = $stdout # rubocop:disable RSpec/LeakyLocalVariable

  let(:registration) { create(:registration) }

  before do
    # suppress noisy outputs during unit test
    $stdout = StringIO.new
  end

  after do
    $stdout = original_stdout
  end

  it "runs without error with a valid registration reference" do
    expect { Rake::Task[subject].invoke(registration.reference) }.not_to raise_error
  end

  it "runs without error with an invalid registration reference" do
    expect { Rake::Task[subject].invoke("foo") }.not_to raise_error
  end
end
# rubocop:enable RSpec/ExpectOutput
