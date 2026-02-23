# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/RepeatedExampleGroupBody
RSpec.describe "Reports task", type: :rake do
  include_context "rake"

  describe "reports:export:finance_data" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "reports:export:epr" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "reports:export:bulk" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "reports:export:boxi" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

end
# rubocop:enable RSpec/RepeatedExampleGroupBody
