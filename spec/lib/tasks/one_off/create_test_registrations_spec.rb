# frozen_string_literal: true

require "rails_helper"
require_relative "../../../../db/seeds/charging_schemes"

RSpec.describe "one_off:create_test_registrations", type: :rake do
  subject(:run_rake_task) { rake_task.invoke(count, expiry_date) }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:create_test_registrations"] }
  let(:count) { 2 }
  let(:expiry_date) { "2028-01-01" }

  before { seed_charging_schemes }

  after { rake_task.reenable }

  it "creates the specified number of registrations" do
    expect { run_rake_task }.to change(WasteExemptionsEngine::Registration, :count).by(2)
  end

  it "creates registrations with the specified expiry date" do
    run_rake_task

    registration = WasteExemptionsEngine::Registration.last
    expect(registration.registration_exemptions.first.expires_on).to eq(Date.parse(expiry_date))
  end

  it "creates orders for each registration" do
    expect { run_rake_task }.to change(WasteExemptionsEngine::Order, :count).by(2)
  end
end
