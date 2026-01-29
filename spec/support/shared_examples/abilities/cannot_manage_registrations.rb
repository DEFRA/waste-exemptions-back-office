# frozen_string_literal: true

RSpec.shared_examples "cannot manage registrations" do
  it { expect(subject).not_to be_able_to(:create, registration) }
  it { expect(subject).not_to be_able_to(:update, registration) }
  it { expect(subject).not_to be_able_to(:update_expiry_date, registration) }

  it { expect(subject).not_to be_able_to(:create, new_charged_registration) }
  it { expect(subject).not_to be_able_to(:update, new_charged_registration) }

  it { expect(subject).not_to be_able_to(:deregister, registration) }
  it { expect(subject).not_to be_able_to(:deregister, registration_exemption) }
end
