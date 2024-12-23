# frozen_string_literal: true

RSpec.shared_examples "cannot refund payments" do
  it { expect(subject).not_to be_able_to(:refund_payment, registration) }
end
