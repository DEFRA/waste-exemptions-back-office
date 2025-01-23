# frozen_string_literal: true

RSpec.shared_examples "can start private beta registrations" do
  it { expect(subject).to be_able_to(:start_private_beta_registration, registration)}
end
