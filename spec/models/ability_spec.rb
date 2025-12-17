# frozen_string_literal: true

require "cancan/matchers"
require "rails_helper"

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  let(:site) { build(:address, :site_address) }
  let(:registration) { build(:registration, site_addresses: [site]) }
  let(:registration_exemption) { build(:registration_exemption) }
  let(:new_registration) { build(:new_registration) }

  before do
    site.registration_exemptions << registration_exemption
  end

  RSpec.shared_examples "can use back office" do
    it { expect(subject).to be_able_to(:use_back_office, :all) }
  end

  context "when the user role is admin_team_user" do
    let(:user) { build(:user, :admin_team_user) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage users"
    it_behaves_like "can manage registrations"
    it_behaves_like "can add charge adjustments"
    it_behaves_like "can add payments"
    it_behaves_like "can reverse payments"
    it_behaves_like "can write-off payments"

    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).to be_able_to(:read, Reports::Download) }

    it_behaves_like "cannot manage charges and bands"
    it_behaves_like "cannot refund payments"
    it_behaves_like "can mark legacy bulk or linear"

    it { expect(ability).not_to be_able_to(:read_finance_data, Reports::GeneratedReport) }
  end

  context "when the user role is customer_service_adviser" do
    let(:user) { build(:user, :customer_service_adviser) }

    it_behaves_like "can use back office"
    it_behaves_like "can view registrations"

    it_behaves_like "cannot manage users"
    it_behaves_like "cannot manage charges and bands"
    it_behaves_like "cannot add charge adjustments"
    it_behaves_like "cannot add payments"
    it_behaves_like "cannot reverse payments"
    it_behaves_like "cannot refund payments"
    it_behaves_like "cannot write-off payments"
    it_behaves_like "cannot deregister registrations"
    it_behaves_like "cannot deregister sites"
    it_behaves_like "cannot mark legacy bulk or linear"

    it { expect(ability).not_to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).not_to be_able_to(:read, Reports::GeneratedReport) }
    it { expect(ability).not_to be_able_to(:read_finance_data, Reports::GeneratedReport) }
  end

  context "when the user role is data_viewer" do
    let(:user) { build(:user, :data_viewer) }

    it_behaves_like "can use back office"
    it_behaves_like "can view registrations"

    it { expect(ability).to be_able_to(:read, Reports::GeneratedReport) }

    it_behaves_like "cannot manage users"
    it_behaves_like "cannot manage registrations"
    it_behaves_like "cannot manage charges and bands"
    it_behaves_like "cannot add charge adjustments"
    it_behaves_like "cannot add payments"
    it_behaves_like "cannot reverse payments"
    it_behaves_like "cannot refund payments"
    it_behaves_like "cannot write-off payments"
    it_behaves_like "cannot deregister registrations"
    it_behaves_like "cannot deregister sites"
    it_behaves_like "cannot mark legacy bulk or linear"

    it { expect(ability).not_to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).not_to be_able_to(:read_finance_data, Reports::GeneratedReport) }
  end

  context "when the user role is developer" do
    let(:user) { build(:user, :developer) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage registrations"
    it_behaves_like "can manage charges and bands"
    it_behaves_like "can add charge adjustments"
    it_behaves_like "can add payments"
    it_behaves_like "can reverse payments"
    it_behaves_like "can refund payments"
    it_behaves_like "can write-off payments"
    it_behaves_like "can deregister registrations"
    it_behaves_like "can deregister sites"

    it { expect(ability).to be_able_to(:manage, WasteExemptionsEngine::FeatureToggle) }
    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).to be_able_to(:read_finance_data, Reports::GeneratedReport) }

    it_behaves_like "cannot manage users"
    it_behaves_like "can mark legacy bulk or linear"
  end

  context "when the user role is service_manager" do
    let(:user) { build(:user, :service_manager) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage users"
    it_behaves_like "can manage registrations"
    it_behaves_like "can manage charges and bands"
    it_behaves_like "can deregister registrations"
    it_behaves_like "can deregister sites"
    it_behaves_like "cannot mark legacy bulk or linear"

    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).to be_able_to(:read, Reports::Download) }
    it { expect(ability).to be_able_to(:read_finance_data, Reports::GeneratedReport) }

    it_behaves_like "cannot add charge adjustments"
    it_behaves_like "cannot add payments"
    it_behaves_like "cannot reverse payments"
    it_behaves_like "cannot refund payments"
    it_behaves_like "cannot write-off payments"
  end

  context "when the user role is admin_team_lead" do
    let(:user) { build(:user, :admin_team_lead) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage users"
    it_behaves_like "can manage registrations"
    it_behaves_like "can add payments"
    it_behaves_like "can reverse payments"
    it_behaves_like "can refund payments"
    it_behaves_like "can write-off payments"
    it_behaves_like "can deregister registrations"
    it_behaves_like "can deregister sites"

    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).to be_able_to(:read, Reports::Download) }
    it { expect(ability).to be_able_to(:read_finance_data, Reports::GeneratedReport) }
    it { expect(ability).to be_able_to(:reset_transient_registrations, registration) }

    it_behaves_like "cannot manage charges and bands"
    it_behaves_like "cannot add charge adjustments"
    it_behaves_like "cannot mark legacy bulk or linear"
  end

  context "when the user role is policy_adviser" do
    let(:user) { build(:user, :policy_adviser) }

    it_behaves_like "can use back office"
    it_behaves_like "can manage users"
    it_behaves_like "can manage charges and bands"

    it { expect(ability).to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).to be_able_to(:read, Reports::Download) }
    it { expect(ability).to be_able_to(:read_finance_data, Reports::GeneratedReport) }

    it_behaves_like "cannot manage registrations"
    it_behaves_like "cannot add charge adjustments"
    it_behaves_like "cannot add payments"
    it_behaves_like "cannot reverse payments"
    it_behaves_like "cannot refund payments"
    it_behaves_like "cannot write-off payments"
    it_behaves_like "cannot deregister registrations"
    it_behaves_like "cannot deregister sites"
    it_behaves_like "cannot mark legacy bulk or linear"
  end

  context "when the user role is finance_user" do
    let(:user) { build(:user, :finance_user) }

    it_behaves_like "can use back office"
    it_behaves_like "can add payments"
    it_behaves_like "can reverse payments"
    it_behaves_like "can refund payments"
    it_behaves_like "can write-off payments"

    it_behaves_like "cannot manage users"
    it_behaves_like "cannot manage registrations"
    it_behaves_like "cannot manage charges and bands"
    it_behaves_like "cannot add charge adjustments"
    it_behaves_like "cannot deregister registrations"
    it_behaves_like "cannot deregister sites"
    it_behaves_like "cannot mark legacy bulk or linear"

    it { expect(ability).not_to be_able_to(:read, Reports::DefraQuarterlyStatsService) }
    it { expect(ability).not_to be_able_to(:read, Reports::Download) }
    it { expect(ability).not_to be_able_to(:read_finance_data, Reports::GeneratedReport) }
    it { expect(ability).not_to be_able_to(:read, Reports::GeneratedReport) }
  end

  context "when the user account is inactive" do
    let(:user) { build(:user, :data_viewer, :inactive) }

    it "is not able to use the back office" do
      expect(ability).not_to be_able_to(:use_back_office, :all)
    end
  end
end
