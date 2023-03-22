# frozen_string_literal: true

RSpec.shared_examples "developer examples" do
  it "is able to toggle features" do
    expect(subject).to be_able_to(:manage, WasteExemptionsEngine::FeatureToggle)
  end

  it "is able to view DEFRA quarterly reports" do
    expect(subject).to be_able_to(:read, Reports::DefraQuarterlyStatsService)
  end

  it "is able to export deregistration email batches" do
    expect(subject).to be_able_to(:manage, DeregistrationEmailExportsForm)
  end
end
