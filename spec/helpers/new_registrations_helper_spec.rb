# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewRegistrationsHelper do
  let(:resource) { build(:new_registration) }

  describe "#back_path" do
    context "when the back_to param is present" do
      before do
        allow(helper).to receive(:params).and_return({ back_to: "/some-path" })
      end
  
      it "returns the back_to param" do
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
