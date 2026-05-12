# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditCompleteForm, type: :model do
  subject(:form) { build(:edit_complete_form) }

  let(:edit_registration) { form.transient_registration }

  describe "#reference" do
    it "delegates to the transient registration" do
      expect(form.reference).to eq(edit_registration.reference)
    end
  end

  describe "#submit" do
    it "raises an error" do
      expect { form.submit({}) }.to raise_error(WasteExemptionsEngine::UnsubmittableForm)
    end
  end
end
