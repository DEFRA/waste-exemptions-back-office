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
      it "returns the back_to param" do
        helper.params = { back_to: "/some-path" }
        expect(helper.back_path).to eq "/some-path"
      end
    end

    context "when the back_to param is not present" do
      it "returns the root path" do
        expect(helper.back_path).to eq root_path
      end
    end
  end
end
