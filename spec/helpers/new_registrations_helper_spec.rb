# frozen_string_literal: true

require "rails_helper"

class DummyClass
  include NewRegistrationsHelper

  attr_accessor :params, :root_path
end

RSpec.describe NewRegistrationsHelper do
  let(:resource) { build(:new_registration) }
  let(:helper) do
    helper = DummyClass.new
    helper.params = {}
    helper.root_path = root_path
    helper
  end

  describe "#back_path" do
    context "when the back_to param is present" do
      before do
        helper.params = { back_to: "/some-path" }
      end

      it_behaves_like "returns the back_to param"
    end

    context "when the back_to param is not present" do
      it_behaves_like "returns the root path"
    end
  end
end
