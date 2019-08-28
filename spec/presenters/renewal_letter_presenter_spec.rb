# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalLetterPresenter do
  let(:registration) { create(:registration, :with_active_exemptions) }
  subject { described_class.new(registration) }

  it_behaves_like "a letter presenter"

  describe "#expiry_date" do
    it "returns the registration's expiry_date formatted as for example '2 April 2019'" do
      parsed_date = Date.parse(subject.expiry_date)

      expect(parsed_date).to eq(registration.registration_exemptions.first.expires_on)
    end
  end

  describe "#exemption_description" do
    it "returns the exemption code and summary in the correct format" do
      exemption = build(:exemption)
      string = "#{exemption.code} #{exemption.summary}"

      expect(subject.exemption_description(exemption)).to eq(string)
    end
  end

  describe "#listable_exemptions" do
    context "when there are 20 or fewer exemptions" do
      it "returns all exemptions" do
        expect(subject.listable_exemptions).to eq(registration.exemptions)
      end
    end

    context "when there are more than 20 exemptions" do
      before do
        registration.exemptions = build_list(:exemption, 21)
      end

      it "only returns the first 20" do
        expect(subject.listable_exemptions).to eq(registration.exemptions.first(20))
      end
    end
  end

  describe "#unlisted_exemption_count" do
    context "when there are 20 or fewer exemptions" do
      it "returns 0" do
        expect(subject.unlisted_exemption_count).to eq(0)
      end
    end

    context "when there are more than 20 exemptions" do
      before do
        registration.exemptions = build_list(:exemption, 21)
      end

      it "returns the count minus 20" do
        expect(subject.unlisted_exemption_count).to eq(1)
      end
    end
  end
end
