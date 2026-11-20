# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationsHelper do
  let(:resource) { build(:new_charged_registration) }

  describe "#contact_data_present?" do
    context "when the resource has data in at least one relevant field" do
      before { resource.contact_first_name = "Foo" }

      it "returns true" do
        expect(helper.contact_data_present?(resource)).to be(true)
      end
    end

    context "when the resource does not have data in the relevant fields" do
      before do
        resource.contact_first_name = nil
        resource.contact_last_name = nil
        resource.contact_phone = nil
        resource.contact_email = nil
        resource.contact_position = nil
      end

      it "returns true" do
        expect(helper.contact_data_present?(resource)).to be(false)
      end
    end
  end

  describe "#renewal_history" do
    let(:original_registration) { create(:registration) }
    let(:previous_registration) { create(:registration, referring_registration: original_registration) }
    let(:current_registration) { create(:registration, referring_registration: previous_registration) }

    it "returns an array of registrations in reverse chronological order" do
      expect(helper.renewal_history(current_registration)).to eq [
        current_registration,
        previous_registration,
        original_registration
      ]
    end
  end

  describe "#registration_date_range" do
    context "with a registration" do
      let(:registration) { create(:registration) }

      it do
        expect(helper.registration_date_range(registration))
          .to eq "(#{registration.created_at.strftime('%-d %B %Y')} to #{registration.expires_on.strftime('%-d %B %Y')})"
      end
    end

    context "with a transient registration" do
      let(:registration) { create(:new_charged_registration) }

      it do
        expect(helper.registration_date_range(registration))
          .to eq "(created on #{registration.created_at.strftime('%-d %B %Y')})"
      end
    end
  end

  describe "#registration_details_link_with_dates" do
    subject(:link_response) { helper.registration_details_link_with_dates(registration) }

    let(:registration) { create(:registration) }

    it "returns a link to the details page for the registration" do
      expect(link_response).to match(%r{href="/registrations/#{registration.reference}"})
    end

    it "includes the date range for the registration" do
      expect(link_response).to include(helper.registration_date_range(registration))
    end
  end

  describe "#registration_status" do
    let(:registration) { create(:registration, registration_exemptions: registration_exemptions) }

    context "when the registration is active" do
      let(:registration_exemptions) { build_list(:registration_exemption, 1, :active) }

      it "returns the active status" do
        expect(helper.registration_status(registration)).to eq "Active"
      end
    end

    context "when the registration has an outstanding charge" do
      let(:registration_exemptions) { build_list(:registration_exemption, 1, :active) }

      before { allow(registration).to receive(:pending_payment?).and_return(true) }

      it "returns the pending payment status" do
        expect(helper.registration_status(registration)).to eq "Active - pending payment"
      end
    end

    context "when the registration is expired" do
      let(:registration_exemptions) do
        build_list(:registration_exemption, 1, :expired, expires_on: Date.new(2028, 12, 22))
      end

      it "returns the status with the expiry date" do
        expect(helper.registration_status(registration)).to eq "Expired (22 December 2028)"
      end
    end

    context "when the registration is ceased" do
      let(:registration_exemptions) do
        build_list(:registration_exemption, 1, :ceased, deregistered_at: Date.new(2026, 10, 23))
      end

      it "returns the status with the date it was ceased" do
        expect(helper.registration_status(registration)).to eq "Ceased (23 October 2026)"
      end
    end

    context "when the registration is revoked" do
      let(:registration_exemptions) do
        build_list(:registration_exemption, 1, :revoked, deregistered_at: Date.new(2026, 10, 23))
      end

      it "returns the status with the date it was revoked" do
        expect(helper.registration_status(registration)).to eq "Revoked (23 October 2026)"
      end
    end

    context "when a deregistered registration has no deregistration date" do
      let(:registration_exemptions) do
        build_list(:registration_exemption, 1, :ceased, deregistered_at: nil)
      end

      it "returns the status on its own" do
        expect(helper.registration_status(registration)).to eq "Ceased"
      end
    end
  end

  describe "#registration_status_heading_suffix" do
    let(:registration) { create(:registration, registration_exemptions: registration_exemptions) }

    context "when the registration is active" do
      let(:registration_exemptions) { build_list(:registration_exemption, 1, :active) }

      it "returns an empty string" do
        expect(helper.registration_status_heading_suffix(registration)).to eq ""
      end
    end

    context "when the registration has an outstanding charge" do
      let(:registration_exemptions) { build_list(:registration_exemption, 1, :active) }

      before { allow(registration).to receive(:pending_payment?).and_return(true) }

      it "returns the pending payment suffix" do
        expect(helper.registration_status_heading_suffix(registration)).to eq " (Pending payment)"
      end
    end

    %w[expired ceased revoked].each do |state|
      context "when the registration is #{state}" do
        let(:registration_exemptions) { build_list(:registration_exemption, 1, state.to_sym) }

        it "returns the #{state} suffix without a date" do
          expect(helper.registration_status_heading_suffix(registration)).to eq " (#{state.capitalize})"
        end
      end
    end
  end

  describe "#back_path" do
    context "when the back_to param is present" do
      before do
        allow(helper).to receive(:params).and_return({ back_to: "/some-path" })
      end

      it_behaves_like "returns the back_to param"
    end

    context "when the back_to param is not present" do
      it_behaves_like "returns the root path"
    end
  end
end
