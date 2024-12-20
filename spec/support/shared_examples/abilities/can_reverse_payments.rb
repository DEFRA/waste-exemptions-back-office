# frozen_string_literal: true

RSpec.shared_examples "can reverse payments" do
  it { expect(subject).to be_able_to(:reverse_payment, registration) }
end
