# frozen_string_literal: true

RSpec.shared_examples "cannot manage charges and bands" do
  it { expect(subject).not_to be_able_to(:manage_charges, user) }
end
