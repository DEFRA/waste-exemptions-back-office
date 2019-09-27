# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Reports task" do
  include_context "rake"

  describe "reports:export:bulk" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "reports:export:epr" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

  describe "reports:export:boxi" do
    let(:task_name) { self.class.description }

    it "runs without error" do

      expect { subject.invoke }.not_to raise_error
    end
  end

end