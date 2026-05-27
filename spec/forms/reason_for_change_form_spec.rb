# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReasonForChangeForm, type: :model do
  subject(:form) { build(:reason_for_change_form) }

  let(:edit_registration) { form.transient_registration }

  describe "#submit" do
    context "when the form is valid" do
      it "updates the transient registration with the reason for change text" do
        reason_for_change = "Correcting registration details"
        valid_params = { reason_for_change: reason_for_change }

        aggregate_failures do
          expect(edit_registration.reason_for_change).to be_blank
          form.submit(valid_params)
          expect(edit_registration.reason_for_change).to eq(reason_for_change)
        end
      end
    end

    it "does not submit without a reason for change" do
      expect(form.submit(reason_for_change: nil)).to be(false)
    end

    it "does not submit when the reason for change is too long" do
      expect(form.submit(reason_for_change: "a" * 501)).to be(false)
    end
  end

  describe ".can_navigate_flexibly?" do
    it "returns false" do
      expect(described_class).not_to be_can_navigate_flexibly
    end
  end
end
