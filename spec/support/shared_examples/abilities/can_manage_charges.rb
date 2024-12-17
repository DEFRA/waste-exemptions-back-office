# frozen_string_literal: true

RSpec.shared_examples "can manage charges and bands" do
  it { expect(subject).to be_able_to(:manage_charges, user) }
end
