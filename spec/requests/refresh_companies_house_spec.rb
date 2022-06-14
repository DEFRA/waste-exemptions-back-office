# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Refresh companies house", type: :request do
  describe "PATCH /bo/registrations/:reg_identifier/companies_house_name" do

    subject { patch refresh_companies_house_name_path(registration.reference) }

    RSpec.shared_examples "all companies house details requests" do

      it "redirects to the same page" do
        subject
        expect(response.status).to eq 302
        expect(response.location).to end_with registration_path(registration.reference)
      end

      it "returns a success message" do
        success_message = I18n.t("refresh_companies_house_name.messages.success")
        patch request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
        follow_redirect!

        expect(response.body).to include(success_message)
      end
    end

    let(:user) { create(:user) }
    let(:new_registration_name) { Faker::Company.name }
    let(:registration) { create(:registration, operator_name: old_registered_name) }
    let(:request_path) { "/companies-house-details/#{registration.reference}" }

    before do
      sign_in(user)
      stub_request(:get, "#{Rails.configuration.companies_house_host}#{registration.company_no}").to_return(
        status: 200,
        body: { company_name: new_registration_name }.to_json
      )
    end

    context "with no previous companies house name" do
      let(:old_registered_name) { nil }

      it_behaves_like "all companies house details requests"
    end

    context "with an existing registered company name" do
      let(:old_registered_name) { Faker::Company.name }

      context "when the new company name is the same as the old one" do
        let(:new_registration_name) { old_registered_name }

        it_behaves_like "all companies house details requests"
      end

      context "when the new company name is different to the old one" do
        it_behaves_like "all companies house details requests"
      end
    end

    context "when an error happens" do
      let(:old_registered_name) { Faker::Company.name }

      before do
        expect(WasteExemptionsEngine::RefreshCompaniesHouseNameService).to receive(:run).and_raise(StandardError)
      end

      it "returns an error message" do
        error_message = I18n.t("refresh_companies_house_name.messages.failure")

        patch request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
        follow_redirect!

        expect(response.body).to include(error_message)
      end
    end
  end
end
