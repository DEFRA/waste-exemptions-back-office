# frozen_string_literal: true

RSpec.shared_examples "can restore registrations" do
  it "can restore a deregistered registration" do
    registration.registration_exemptions.each { |re| re.state = "revoked" }

    expect(ability).to be_able_to(:restore, registration)
  end

  it "cannot restore an active registration" do
    expect(ability).not_to be_able_to(:restore, registration)
  end
end
