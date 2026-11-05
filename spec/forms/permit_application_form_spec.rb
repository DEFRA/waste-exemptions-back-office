# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermitApplicationForm do
  subject(:form) { described_class.new(registration: registration) }

  let(:registration) { create(:registration) }
  let(:params) { { permit_application_number: "EPR/AB1234CD/A001", permit_application_status: "issued" } }

  describe "#submit" do
    context "with valid params" do
      it { expect(form.submit(params)).to be(true) }

      it "updates the registration" do
        form.submit(params)

        expect(registration.reload).to have_attributes(
          permit_application_number: "EPR/AB1234CD/A001",
          permit_application_status: "issued"
        )
      end

      it "strips whitespace from the permit application number" do
        form.submit(params.merge(permit_application_number: "  EPR/AB1234CD/A001  "))

        expect(registration.reload.permit_application_number).to eq("EPR/AB1234CD/A001")
      end
    end

    context "when the permit application number is blank" do
      it "is invalid and does not update the registration" do
        expect(form.submit(params.merge(permit_application_number: ""))).to be(false)
        expect(form.errors[:permit_application_number]).to be_present
        expect(registration.reload.permit_application_number).to be_nil
      end
    end

    context "when the permit application status is not recognised" do
      it "is invalid" do
        expect(form.submit(params.merge(permit_application_status: "foo"))).to be(false)
        expect(form.errors[:permit_application_status]).to be_present
      end
    end
  end

  describe "#status_options" do
    it "returns an option for every status" do
      expect(form.status_options.map(&:id)).to eq(WasteExemptionsEngine::Registration::PERMIT_APPLICATION_STATUSES)
    end
  end
end
