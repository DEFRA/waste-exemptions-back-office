# frozen_string_literal: true

RSpec.shared_examples "cannot restore registrations" do
  let(:deregistered_registration) do
    registration.tap do |reg|
      reg.registration_exemptions.each { |re| re.state = "revoked" }
    end
  end

  it { expect(ability).not_to be_able_to(:restore, deregistered_registration) }
end
