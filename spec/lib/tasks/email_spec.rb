# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/RepeatedExampleGroupBody
RSpec.describe "Email task", type: :rake do
  include_context "rake"

  describe "email:test" do
    it "runs without error" do
      expect { subject.invoke }.to output(/From: Waste Exemptions Service/).to_stdout
    end
  end

  describe "email:anonymise" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "email:renew_reminder:first:send" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "email:renew_reminder:second:send" do
    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end

end
# rubocop:enable RSpec/RepeatedExampleGroupBody
