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

  describe "#private_beta_participant?" do
    subject(:is_private_beta) { helper.private_beta_participant?(resource) }

    shared_examples "is / is not a private beta participant" do
      context "when the resource is not associated with a beta_participant" do
        it { expect(is_private_beta).to be false }
      end

      context "when the resource is associated with a beta_participant" do
        before { create(:beta_participant, registration: resource) }

        it { expect(is_private_beta).to be true }
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { create(:new_registration) }

      it_behaves_like "is / is not a private beta participant"
    end

    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it_behaves_like "is / is not a private beta participant"
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
