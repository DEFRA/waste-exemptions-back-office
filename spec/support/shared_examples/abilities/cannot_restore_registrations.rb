# frozen_string_literal: true

RSpec.shared_examples "cannot restore registrations" do
  it "cannot restore a deregistered registration" do
    registration.registration_exemptions.each { |re| re.state = "revoked" }

    expect(ability).not_to be_able_to(:restore, registration)
  end
end
