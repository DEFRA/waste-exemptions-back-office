# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reminder task", type: :rake do
  include_context "rake"

  before(:each) { create(:registration, :with_active_exemptions) }

  describe "reminder:first" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "reminder:second" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

end
