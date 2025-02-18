# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderTextService do
  describe "#template" do
    it "raises NotImplementedError" do
      expect { described_class.new.template }.to raise_error(NotImplementedError)
    end
  end

  describe "#template_label" do
    it "raises NotImplementedError" do
      expect { described_class.new.template_label }.to raise_error(NotImplementedError)
    end
  end
end
