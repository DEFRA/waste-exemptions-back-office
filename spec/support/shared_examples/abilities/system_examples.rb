# frozen_string_literal: true

RSpec.shared_examples "system examples" do
  it "is able to invite a user" do
    expect(subject).to be_able_to(:invite, user)
  end

  it "is able to view a user" do
    expect(subject).to be_able_to(:read, user)
  end

  it "is able to change the role of a user" do
    expect(subject).to be_able_to(:change_role, user)
  end

  it "is able to activate or deactivate a user" do
    expect(subject).to be_able_to(:activate_or_deactivate, user)
  end
end
