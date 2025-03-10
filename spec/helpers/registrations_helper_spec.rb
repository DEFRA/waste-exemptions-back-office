# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationsHelper do
  let(:resource) { build(:new_registration) }

  describe "#applicant_data_present?" do
    context "when the resource has data in at least one relevant field" do
      before { resource.applicant_first_name = "Foo" }

      it "returns true" do
        expect(helper.applicant_data_present?(resource)).to be(true)
      end
    end

    context "when the resource does not have data in the relevant fields" do
      before do
        resource.applicant_first_name = nil
        resource.applicant_last_name = nil
        resource.applicant_phone = nil
        resource.applicant_email = nil
      end

      it "returns true" do
        expect(helper.applicant_data_present?(resource)).to be(false)
      end
    end
  end

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

    context "with a new_registration" do
      let(:registration) { create(:new_registration) }

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
