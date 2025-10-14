# frozen_string_literal: true

RSpec.shared_examples "can deregister sites" do
  it { expect(ability).to be_able_to(:deregister, site) }
end
