# frozen_string_literal: true

RSpec.shared_examples "cannot write-off payments" do
  it { expect(subject).not_to be_able_to(:writeoff_payment, registration) }
end
