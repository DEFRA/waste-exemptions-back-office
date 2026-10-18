# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReformCommsLetterRecipientPresenter do
  subject(:presenter) { described_class.new(registration) }

  let(:registration) { create(:registration, contact_first_name: " Jane ", contact_last_name: "van  Smith") }

  before do
    registration.contact_address.update(organisation: nil, premises: " 1 ", street_address: "High  Street",
                                        locality: "", city: "Bristol", postcode: "BS1 1AA")
  end

  describe "#first_name" do
    it "returns the contact first name without extra spaces" do
      expect(presenter.first_name).to eq("Jane")
    end
  end

  describe "#last_name" do
    it "returns the contact last name without extra spaces" do
      expect(presenter.last_name).to eq("van Smith")
    end
  end

  describe "#address_lines" do
    it "returns the contact address lines without extra spaces, skipping blank ones" do
      expect(presenter.address_lines).to eq(["1", "High Street", "Bristol", "BS1 1AA"])
    end
  end

  describe "#recipient" do
    it "returns the contact name and address lines" do
      expect(presenter.recipient).to eq("Jane van Smith, 1, High Street, Bristol, BS1 1AA")
    end
  end
end
