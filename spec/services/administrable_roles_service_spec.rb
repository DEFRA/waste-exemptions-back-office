# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdministrableRolesService do
  describe ".call" do
    context "when user role is admin_team_user" do
      let(:user) { build(:user, role: "admin_team_user") }

      it "returns list of group roles" do
        expect(described_class.call(user)).to eq(%w[admin_team_user customer_service_adviser data_viewer])
      end
    end

    context "when user role is service_manager" do
      let(:user) { build(:user, role: "service_manager") }

      it "returns list of group roles" do
        expect(described_class.call(user)).to eq(%w[customer_service_adviser
                                                    data_viewer
                                                    finance_user
                                                    developer
                                                    service_manager
                                                    admin_team_user
                                                    admin_team_lead
                                                    policy_adviser])
      end
    end

    context "when user role is admin_team_lead" do
      let(:user) { build(:user, role: "admin_team_lead") }

      it "returns list of group roles" do
        expect(described_class.call(user)).to eq(%w[customer_service_adviser
                                                    data_viewer
                                                    admin_team_user
                                                    admin_team_lead])
      end
    end

    context "when user role is policy_adviser" do
      let(:user) { build(:user, role: "policy_adviser") }

      it "returns list of group roles" do
        expect(described_class.call(user)).to eq(%w[policy_adviser
                                                    data_viewer])
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
