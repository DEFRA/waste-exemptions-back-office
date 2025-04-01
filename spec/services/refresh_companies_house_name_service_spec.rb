# frozen_string_literal: true

require "rails_helper"
require "defra_ruby/companies_house"

RSpec.describe RefreshCompaniesHouseNameService do
  describe ".run" do

    subject(:run_service) { described_class.run(reference) }

    let(:new_registration_name) { Faker::Company.name }
    let(:registration) { create(:registration, operator_name: old_registered_name) }
    let(:reference) { registration.reference }
    let(:companies_house_name) { new_registration_name }
    let(:companies_house_api) { instance_double(DefraRuby::CompaniesHouse::API) }
    let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }
    let(:companies_house_api_response) do
      {
        company_name: companies_house_name,
        registered_office_address: company_address
      }
    end

    before do
      allow(DefraRuby::CompaniesHouse::API).to receive(:new).and_return(companies_house_api)
      allow(companies_house_api).to receive(:run).and_return(companies_house_api_response)
    end

    context "with no previous companies house name" do
      let(:old_registered_name) { nil }

      it "stores the companies house name" do
        expect { run_service }.to change { registration_data(registration).operator_name }
          .from(nil)
          .to(new_registration_name)
      end

      it "does set the reason_for_change" do
        expect { run_service }.to change { registration_data(registration).reason_for_change }.to I18n.t("refresh_companies_house_name.messages.reason_for_change")
      end
    end

    context "when an error happens" do
      before do
        allow(companies_house_api).to receive(:run).and_raise(StandardError)
      end

      let(:old_registered_name) { Faker::Company.name }

      it "raises an error" do
        expect { run_service }.to raise_error(StandardError)
      end

      it "does not change the companies house name" do
        run_service
      rescue StandardError
        expect(registration_data(registration).operator_name).to eq old_registered_name

      end
    end

    context "with an existing registered company name" do
      let(:old_registered_name) { Faker::Company.name }

      context "when the new company name is the same as the old one" do
        let(:new_registration_name) { old_registered_name }

        it "does not change companies house name" do
          expect { run_service }.not_to change { registration_data(registration).operator_name }
        end
      end

      context "when the new company name is different to the old one" do
        it "updates the registered company name" do
          expect { run_service }
            .to change { registration_data(registration).operator_name }
            .from(old_registered_name)
            .to(new_registration_name)
        end

        it "does set the reason_for_change" do
          expect { run_service }.to change { registration_data(registration).reason_for_change }.to I18n.t("refresh_companies_house_name.messages.reason_for_change")
        end
      end
    end
  end

  def registration_data(registration)
    WasteExemptionsEngine::Registration.find_by(reference: registration.reference)
  end
end
