# frozen_string_literal: true

RSpec.shared_examples "cannot invite to private beta" do
  it { expect(subject).not_to be_able_to(:invite_private_beta, registration) }
end
