# frozen_string_literal: true

RSpec.shared_examples "can add payments" do
  it { expect(subject).to be_able_to(:add_payment, registration) }
end
