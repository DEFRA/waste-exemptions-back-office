# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe TrackDownloadService do
    describe ".run" do
      let(:report) { create(:generated_report) }
      let(:user) { create(:user) }
      let(:service) { described_class.new }

      it "creates a download record with the correct attributes" do
        expect do
          service.run(report: report, user: user)
        end.to change(Reports::Download, :count).by(1)

        download = Reports::Download.last
        expect(download.report).to eq(report)
        expect(download.user_id.to_i).to eq(user.id)
        expect(download.downloaded_at).to be_within(1.second).of(Time.zone.now)
      end

      it "raises an error when user is nil" do
        expect do
          service.run(report: report, user: nil)
        end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: User can't be blank")
      end
    end
  end
end
