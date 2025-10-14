# frozen_string_literal: true

RSpec.shared_examples "cannot deregister registrations" do
  it { expect(ability).not_to be_able_to(:deregister, registration) }
end
