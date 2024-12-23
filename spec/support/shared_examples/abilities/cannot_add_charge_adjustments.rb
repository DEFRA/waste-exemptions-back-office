# frozen_string_literal: true

RSpec.shared_examples "cannot add charge adjustments" do
  it { expect(subject).not_to be_able_to(:add_charge_adjustment, registration) }
end
