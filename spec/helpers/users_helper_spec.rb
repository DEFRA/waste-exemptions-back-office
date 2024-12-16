# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper do
  describe "#current_user_group_roles" do
    it "returns a list of group roles for admin_team_user role" do
      current_user = build(:user, role: "admin_team_user")
      expect(helper.current_user_group_roles(current_user)).to eq(["admin_team_user"])
    end

    it "returns an empty list of group roles for developer role" do
      current_user = build(:user, role: "developer")
      expect(helper.current_user_group_roles(current_user)).to eq([])
    end
  end
end
