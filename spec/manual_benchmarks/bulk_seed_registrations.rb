# frozen_string_literal: true

require "rails_helper"

# This is a utility method to generate bulk data for performance testing purposes.
# It makes use of FactoryBot and Timecop, so it has been implemented as a spec
# instead of a rake task to avoid introducing test gem dependencies outside the test env.

# rubocop:disable RSpec/DescribeClass, RSpec/NoExpectationExample, RSpec/Output
RSpec.describe "bulk seed registrations" do
  it "creates registations" do
    registration_count = ENV.fetch("BULK_SEED_REGISTRATION_COUNT").to_i
    puts "Creating #{registration_count} registrations..."

    (1..registration_count).each do |r|
      reg_type = %i[registration renewing_registration].sample
      creation_date = rand(1_000).days.ago
      Timecop.freeze(creation_date) do
        case reg_type
        when :registration
          create(reg_type, submitted_at: creation_date.to_date)
        else
          create(reg_type)
        end
      end
      puts "... #{r}" if (r % 1000).zero?
    end
  end
end
# rubocop:enable RSpec/DescribeClass, RSpec/NoExpectationExample, RSpec/Output
