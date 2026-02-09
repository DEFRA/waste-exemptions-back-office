# frozen_string_literal: true

RSpec.shared_examples "can view registrations" do
  it { expect(subject).to be_able_to(:read, registration) }
  it { expect(subject).to be_able_to(:read, new_charged_registration) }
end
