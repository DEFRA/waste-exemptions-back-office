# frozen_string_literal: true

RSpec.shared_examples "below super_agent examples" do
  it "is not able to update registrations" do
    expect(subject).not_to be_able_to(:update, registration)
  end

  it "is not able to update registration expiry dates" do
    expect(subject).not_to be_able_to(:update_expiry_date, registration)
  end

  it "is not able to deregister registrations" do
    expect(subject).not_to be_able_to(:deregister, registration)
  end

  it "is not able to deregister exemptions" do
    expect(subject).not_to be_able_to(:deregister, registration_exemption)
  end
end
