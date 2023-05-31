# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe RegistrationDeregistrationEmailPresenter do
    let(:registration) { create(:registration) }

    subject(:presenter) { described_class.new(registration) }

    describe "contact_name" do
      it "returns the correct value" do
        expect(presenter.contact_name).to eq("#{registration.contact_first_name} #{registration.contact_last_name}")
      end
    end

    describe "magic_link_url" do
      it "returns the correct value" do
        expect(presenter.magic_link_url).to eq("http://localhost:3000/renew/#{registration.renew_token}")
      end
    end

    describe "site_details" do
      it "returns the correct value" do
        expect(presenter.site_details).to eq("ST 58337 72855")
      end
    end

    describe "exemption_details" do
      let(:expected) do
        registration.exemptions.map do |ex|
          "#{ex.code} #{ex.summary}"
        end.join(", ")
      end

      it "returns the correct value" do
        parts = presenter.exemption_details.split(", ")
        expect(parts.count).to eq(registration.exemptions.count)
        parts.each do |part|
          expect(expected).to include(part)
        end
      end
    end
  end
end
