# frozen_string_literal: true

RSpec.shared_examples "cannot manage permit application" do
  it { expect(subject).not_to be_able_to(:manage_permit_application, registration) }
end
