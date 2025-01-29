# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "returns the back_to param" do
  it { expect(helper.back_path).to eq "/some-path" }
end

RSpec.shared_examples "returns the root path" do
  it { expect(helper.back_path).to eq root_path }
end
