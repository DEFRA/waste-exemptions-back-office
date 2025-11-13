# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardsHelper do
  describe "preselect_registrations_radio_button?" do
    context "when @filter is blank" do
      it "returns true" do
        expect(helper.preselect_registrations_radio_button?).to be(true)
      end
    end

    context "when @filter is set to :registrations" do
      before { assign(:filter, :registrations) }

      it "returns true" do
        expect(helper.preselect_registrations_radio_button?).to be(true)
      end
    end

    context "when @filter is set to :new_registrations" do
      before { assign(:filter, :new_registrations) }

      it "returns false" do
        expect(helper.preselect_registrations_radio_button?).to be(false)
      end
    end
  end

  describe "preselect_new_registrations_radio_button?" do
    context "when @filter is blank" do
      it "returns false" do
        expect(helper.preselect_new_registrations_radio_button?).to be(false)
      end
    end

    context "when @filter is set to :registrations" do
      before { assign(:filter, :registrations) }

      it "returns false" do
        expect(helper.preselect_new_registrations_radio_button?).to be(false)
      end
    end

    context "when @filter is set to :new_registrations" do
      before { assign(:filter, :new_registrations) }

      it "returns true" do
        expect(helper.preselect_new_registrations_radio_button?).to be(true)
      end
    end
  end

  describe "status_tag_for" do
    context "when the result is a new_registration" do
      let(:result) { build(:new_registration) }

      it "returns :pending" do
        expect(helper.status_tag_for(result)).to eq(:pending)
      end
    end

    context "when the result is a new_charged_registration" do
      let(:result) { build(:new_charged_registration) }

      it "returns :pending" do
        expect(helper.status_tag_for(result)).to eq(:pending)
      end
    end

    context "when the result is not a new_registration" do
      let(:result) { build(:registration) }

      it "returns :active" do
        expect(helper.status_tag_for(result)).to eq(result.state)
      end
    end
  end

  describe "result_name_for_visually_hidden_text" do
    let(:result) { build(:new_registration) }

    context "when the result has an operator_name" do
      before { result.operator_name = "Foo" }

      it "returns the operator_name" do
        expect(helper.result_name_for_visually_hidden_text(result)).to eq(result.operator_name)
      end
    end

    context "when the result has no operator_name" do
      before { result.operator_name = nil }

      context "when the result has a reference" do
        before { result.reference = "WEX123456" }

        it "returns the reference" do
          expect(helper.result_name_for_visually_hidden_text(result)).to eq(result.reference)
        end
      end

      context "when the result has no reference" do
        before { result.reference = nil }

        it "returns 'new registration'" do
          expect(helper.result_name_for_visually_hidden_text(result)).to eq("new registration")
        end
      end
    end
  end

  describe "label_for_business" do
    let(:registration) { create(:registration, business_type: business_type) }
    let(:result) { helper.label_for_business(registration) }

    context "when business type is llp", :tag do
      let(:business_type) { "limitedLiabilityPartnership" }

      it { expect(result).to eq("Registered name") }
    end

    context "when business type is ltd" do
      let(:business_type) { "limitedLiabilityPartnership" }

      it { expect(result).to eq("Registered name") }
    end

    context "when business type is anything else" do
      %w[soleTrader partnership localAuthority charity].each do |type|
        let(:business_type) { type }

        it { expect(helper.label_for_business(registration)).to eq("Operator (business) name") }
      end
    end
  end

  describe "resource_heading_for" do
    let(:resource) { build(:registration, reference: "WEX123456") }

    before do
      allow(helper).to receive(:t).with(".heading.linear", reference: "WEX123456").and_return("Linear heading")
      allow(helper).to receive(:t).with(".heading.multisite", reference: "WEX123456").and_return("Multisite heading")
      allow(helper).to receive(:t).with(".heading.regular", reference: "WEX123456").and_return("Regular heading")
    end

    shared_examples "a resource heading" do |heading_type, expected_heading|
      it "returns the #{heading_type} heading translation" do
        expect(helper.resource_heading_for(resource)).to eq(expected_heading)
      end

      it "calls translation with correct key and parameters" do
        helper.resource_heading_for(resource)
        expect(helper).to have_received(:t).with(".heading.#{heading_type}", reference: "WEX123456")
      end
    end

    context "when resource is a regular registration" do
      it_behaves_like "a resource heading", "regular", "Regular heading"
    end

    context "when resource is linear registration" do
      before { resource.is_linear = true }

      it_behaves_like "a resource heading", "linear", "Linear heading"
    end

    context "when resource is legacy bulk registration" do
      before { resource.is_legacy_bulk = true }

      it_behaves_like "a resource heading", "multisite", "Multisite heading"
    end

    context "when resource is multisite registration" do
      before { resource.is_multisite_registration = true }

      it_behaves_like "a resource heading", "multisite", "Multisite heading"
    end
  end
end
