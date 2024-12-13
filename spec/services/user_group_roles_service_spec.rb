# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserGroupRolesService do
  describe ".call" do
    context "when user role is system" do
      let(:user) { build(:user, role: "system") }

      it "returns list of group roles" do
        expect(described_class.call(user)).to eq(%w[system])
      end
    end

    context "when user role is service_manager" do
      let(:user) { build(:user, role: "service_manager") }

      it "returns list of group roles" do
        expect(described_class.call(user)).to eq(%w[admin_agent
                                                    data_agent
                                                    finance_user
                                                    developer
                                                    service_manager
                                                    system
                                                    admin_team_lead
                                                    policy_advisor])
      end
    end

    context "when user role is admin_team_lead" do
      let(:user) { build(:user, role: "admin_team_lead") }

      it "returns list of group roles" do
        expect(described_class.call(user)).to eq(%w[admin_agent
                                                    data_agent
                                                    system
                                                    admin_team_lead])
      end
    end

    context "when user role is policy_adviser" do
      let(:user) { build(:user, role: "policy_adviser") }

      it "returns list of group roles" do
        expect(described_class.call(user)).to eq(%w[policy_advisor
                                                    data_agent])
      end
    end

    context "when user does not fit any predefined group" do
      let(:user) { build(:user, role: "developer") }

      it "returns an empty array" do
        expect(described_class.call(user)).to eq([])
      end
    end
  end
end
