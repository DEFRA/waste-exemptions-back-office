# frozen_string_literal: true

RSpec.shared_examples "super_agent examples" do
  it "is able to update registrations" do
    expect(subject).to be_able_to(:update, registration)
  end

  it "is able to deregister registrations" do
    expect(subject).to be_able_to(:deregister, registration)
  end

  it "is able to deregister exemptions" do
    expect(subject).to be_able_to(:deregister, registration_exemption)
  end
end
