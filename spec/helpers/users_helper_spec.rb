# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper do
  describe "#administrable_user_roles" do
    it "returns a list of group roles for admin_team_user role" do
      current_user = build(:user, role: "admin_team_user")
      expect(helper.administrable_user_roles(current_user)).to eq(%w[admin_team_user customer_service_adviser data_viewer])
    end

    it "returns an empty list of group roles for developer role" do
      current_user = build(:user, role: "developer")
      expect(helper.administrable_user_roles(current_user)).to eq([])
    end
  end
end
