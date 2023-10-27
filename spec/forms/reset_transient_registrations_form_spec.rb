# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResetTransientRegistrationsForm, type: :model do
  subject(:form) { described_class.new(registration) }

  let(:registration) { create(:registration) }

  describe ".new" do
    it "initializes with a registration" do
      expect(form.instance_variable_get(:@registration)).to eq(registration)
    end
  end

  describe "#submit" do
    context "when there are transient registrations associated with the registration reference" do
      let!(:renewing_registration) { create(:renewing_registration, reference: registration.reference) }
      let!(:edit_registration) { create(:back_office_edit_registration, reference: registration.reference) }

      it "deletes all transient registrations associated with the registration reference" do
        expect do
          form.submit
        end.to change {
          WasteExemptionsEngine::TransientRegistration.where(reference: registration.reference).count
        }.from(2).to(0)
      end

      it "returns true" do
        expect(form.submit).to be(true)
      end
    end

    context "when there are no transient registrations associated with the registration reference" do
      it "returns false" do
        expect(form.submit).to be(false)
      end
    end
  end
end
