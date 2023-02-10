# frozen_string_literal: true

RSpec.shared_examples "below admin_agent examples" do
  it "is not able to create registrations" do
    expect(subject).not_to be_able_to(:create, registration)
  end

  it "is not able to create new registrations" do
    expect(subject).not_to be_able_to(:create, new_registration)
  end

  it "is not able to update new registrations" do
    expect(subject).not_to be_able_to(:update, new_registration)
  end

  it "is not able to view DEFRA quarterly reports" do
    expect(subject).not_to be_able_to(:read, Reports::DefraQuarterlyStatsService)
  end
end
