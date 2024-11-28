# frozen_string_literal: true

RSpec.shared_examples "can manage users" do
  it { expect(subject).to be_able_to(:invite, user) }
  it { expect(subject).to be_able_to(:read, user) }
  it { expect(subject).to be_able_to(:change_role, user) }
  it { expect(subject).to be_able_to(:activate_or_deactivate, user) }
end
