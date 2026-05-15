# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConfirmEditCancelledForm, type: :model do
  subject(:form) { build(:confirm_edit_cancelled_form) }

  it "inherits from base form" do
    expect(form).to be_a(WasteExemptionsEngine::BaseForm)
  end

  describe "#submit" do
    it "submits with no attributes" do
      expect(form.submit({})).to be(true)
    end
  end
end
