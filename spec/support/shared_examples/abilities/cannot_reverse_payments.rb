# frozen_string_literal: true

RSpec.shared_examples "cannot reverse payments" do
  it { expect(subject).not_to be_able_to(:reverse_payment, registration) }
end
