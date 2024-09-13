# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::Download do
  let(:download) { described_class.new(user_id: nil) }

  describe "validations" do
    it "validates presence of user_id" do
      expect(download).not_to be_valid
      expect(download.errors[:user_id]).to include("can't be blank")
    end

    it "validates presence of downloaded_at" do
      expect(download).not_to be_valid
      expect(download.errors[:downloaded_at]).to include("can't be blank")
    end

    it "validates presence of report" do
      expect(download).not_to be_valid
      expect(download.errors[:report]).to include("must exist")
    end
  end

  describe "associations" do
    it "belongs to report" do
      association = described_class.reflect_on_association(:report)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
