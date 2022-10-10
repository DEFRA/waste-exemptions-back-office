# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BoxiExportService do
    describe ".run" do
      let(:zip_file_path) { Rails.root.join("tmp/waste_exemptions_rep_daily_full.zip") }
      let(:bucket) { instance_double(DefraRuby::Aws::Bucket) }
      let(:aws_response) { instance_double(DefraRuby::Aws::Response, successful?: true) }

      before { allow(Airbrake).to receive(:notify) }

      it "generates a zip file containing data for BOXI and load it to AWS" do
        # Cleanup before run
        FileUtils.rm_f(zip_file_path)

        # Intercept zip file deletion and block it
        allow(FileUtils).to receive(:rm_f).and_call_original
        allow(FileUtils).to receive(:rm_f).with(zip_file_path)

        allow(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        allow(bucket).to receive(:load).and_return(aws_response)

        expect { described_class.run }.to change { File.exist?(zip_file_path) }.from(false).to(true)

        Zip::File.open(zip_file_path) do |zip_file|
          all_entries = zip_file.entries.map(&:name)

          expect(all_entries).to include("people.csv")
          expect(all_entries).to include("exemptions.csv")
          expect(all_entries).to include("registration_exemptions.csv")
          expect(all_entries).to include("registrations.csv")
          expect(all_entries).to include("addresses.csv")
        end

        # Expect file load to Aws bucket
        expect(bucket).to have_received(:load)

        # Expect no issues
        expect(Airbrake).not_to have_received(:notify)

        # Clean up after run
        File.delete(zip_file_path)
      end

      context "when an error happen" do
        it "logs the issue on Airbrake" do
          allow(Reports::Boxi::AddressesSerializer).to receive(:export_to_file).and_raise(StandardError)

          described_class.run

          expect(Airbrake).to have_received(:notify)
        end
      end
    end
  end
end
