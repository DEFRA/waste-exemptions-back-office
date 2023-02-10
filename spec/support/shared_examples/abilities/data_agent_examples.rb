# frozen_string_literal: true

RSpec.shared_examples "data_agent examples" do
  it "is able to use the back office" do
    expect(subject).to be_able_to(:use_back_office, :all)
  end

  it "is able to view registrations" do
    expect(subject).to be_able_to(:read, registration)
  end

  it "is able to view new registrations" do
    expect(subject).to be_able_to(:read, new_registration)
  end

  it "is able to view bulk exports" do
    expect(subject).to be_able_to(:read, Reports::GeneratedReport)
  end

  it "is not able to view DEFRA quarterly reports" do
    expect(subject).not_to be_able_to(:read, Reports::DefraQuarterlyStatsService)
  end
end
