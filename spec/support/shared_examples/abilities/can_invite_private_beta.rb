# frozen_string_literal: true

RSpec.shared_examples "can invite to private beta" do
  it { expect(subject).to be_able_to(:invite_private_beta, registration) }
end
