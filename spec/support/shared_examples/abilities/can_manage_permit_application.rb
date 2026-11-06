# frozen_string_literal: true

RSpec.shared_examples "can manage permit application" do
  it { expect(subject).to be_able_to(:manage_permit_application, registration) }
end
