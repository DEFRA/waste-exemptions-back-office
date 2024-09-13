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

    it "validates presence of report_type" do
      expect(download).not_to be_valid
      expect(download.errors[:report_type]).to include("can't be blank")
    end

    it "validates presence of report_file_name" do
      expect(download).not_to be_valid
      expect(download.errors[:report_file_name]).to include("can't be blank")
    end
  end
end
