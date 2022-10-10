# frozen_string_literal: true

RSpec.shared_examples "developer examples" do
  it "is able to toggle features" do
    expect(subject).to be_able_to(:manage, WasteExemptionsEngine::FeatureToggle)
  end
end
