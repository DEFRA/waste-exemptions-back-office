# frozen_string_literal: true

RSpec.shared_examples "can deregister registrations" do
  it { expect(ability).to be_able_to(:deregister, registration) }
end
