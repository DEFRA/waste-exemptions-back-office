# frozen_string_literal: true

RSpec.shared_examples "admin_agent examples" do
  it "is able to create registrations" do
    expect(subject).to be_able_to(:create, registration)
  end

  it "is able to create new registrations" do
    expect(subject).to be_able_to(:create, new_registration)
  end

  it "is able to update new registrations" do
    expect(subject).to be_able_to(:update, new_registration)
  end
end
