# frozen_string_literal: true

RSpec.shared_examples "can add charge adjustments" do
  it { expect(subject).to be_able_to(:add_charge_adjustment, registration) }
end
