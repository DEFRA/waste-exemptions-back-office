# frozen_string_literal: true

RSpec.shared_examples "can write-off payments" do
  it { expect(subject).to be_able_to(:writeoff_payment, registration) }
end
