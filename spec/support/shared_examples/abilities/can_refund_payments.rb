# frozen_string_literal: true

RSpec.shared_examples "can refund payments" do
  it { expect(subject).to be_able_to(:refund_payment, registration) }
end
