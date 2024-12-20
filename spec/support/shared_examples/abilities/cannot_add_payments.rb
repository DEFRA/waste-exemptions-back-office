# frozen_string_literal: true

RSpec.shared_examples "cannot add payments" do
  it { expect(subject).not_to be_able_to(:add_payment, registration) }
end
