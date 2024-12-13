# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper do
  describe "#current_user_group_roles" do
    it "returns a list of group roles for system role" do
      current_user = build(:user, role: "system")
      expect(helper.current_user_group_roles(current_user)).to eq(["system"])
    end

    it "returns an empty list of group roles for developer role" do
      current_user = build(:user, role: "developer")
      expect(helper.current_user_group_roles(current_user)).to eq([])
    end
  end
end
