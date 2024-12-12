# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  let(:registration) { build(:registration) }
  let(:registration_exemption) { build(:registration_exemption) }
  let(:new_registration) { build(:new_registration) }

  RSpec.shared_examples "can use back office" do
    it { expect(subject).to be_able_to(:use_back_office, :all) }
  end

  context "when the user role is system" do
    let(:user) { build(:user, :system) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage users"
    it_behaves_like "can manage registrations"

    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).to be_able_to(:read, Reports::Download) }

    it_behaves_like "cannot manage charges and bands"
  end

  context "when the user role is admin_agent" do
    let(:user) { build(:user, :admin_agent) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage registrations"
    it { expect(ability).to be_able_to(:read, Reports::GeneratedReport) }

    it_behaves_like "cannot manage users"
    it_behaves_like "cannot manage charges and bands"

    it { expect(ability).not_to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
  end

  context "when the user role is data_agent" do
    let(:user) { build(:user, :data_agent) }

    it_behaves_like "can use back office"
    it_behaves_like "can view registrations"

    it { expect(ability).to be_able_to(:read, Reports::GeneratedReport) }

    it_behaves_like "cannot manage users"
    it_behaves_like "cannot manage registrations"
    it_behaves_like "cannot manage charges and bands"

    it { expect(ability).not_to be_able_to(:read, Reports::DefraQuarterlyStatsService) }

  end

  context "when the user role is developer" do
    let(:user) { build(:user, :developer) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage registrations"
    it_behaves_like "can manage charges and bands"

    it { expect(ability).to be_able_to(:manage, WasteExemptionsEngine::FeatureToggle) }
    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }

    it_behaves_like "cannot manage users"
  end

  context "when the user role is service_manager" do
    let(:user) { build(:user, :service_manager) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage users"
    it_behaves_like "can manage registrations"
    it_behaves_like "can manage charges and bands"

    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).to be_able_to(:read, Reports::Download) }

    it { expect(ability).not_to be_able_to(:add_charge_adjustment, registration) }
    it { expect(ability).not_to be_able_to(:add_payment, registration) }
    it { expect(ability).not_to be_able_to(:reverse_payment, registration) }
    it { expect(ability).not_to be_able_to(:refund_payment, registration) }
    it { expect(ability).not_to be_able_to(:writeoff_payment, registration) }
  end

  context "when the user role is wex_admin_team_leader" do
    let(:user) { build(:user, :wex_admin_team_leader) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage users"
    it_behaves_like "can manage registrations"

    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).to be_able_to(:read, Reports::Download) }
    it { expect(ability).to be_able_to(:add_payment, registration) }
    it { expect(ability).to be_able_to(:reverse_payment, registration) }
    it { expect(ability).to be_able_to(:refund_payment, registration) }
    it { expect(ability).to be_able_to(:writeoff_payment, registration) }

    it_behaves_like "cannot manage charges and bands"

    it { expect(ability).not_to be_able_to(:add_charge_adjustment, registration) }
  end

  context "when the user account is inactive" do
    let(:user) { build(:user, :data_agent, :inactive) }

    it "is not able to use the back office" do
      expect(ability).not_to be_able_to(:use_back_office, :all)
    end
  end
end
