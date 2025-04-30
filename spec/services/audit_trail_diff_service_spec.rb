# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuditTrailDiffService do
  let(:service) { described_class }
  let(:version_four) { File.read("./spec/fixtures/files/versions/registration/v1_4.json") }
  # version 5: operator address changed, applicant name changed, contact position changed
  let(:version_five) { File.read("./spec/fixtures/files/versions/registration/v1_5.json") }
  # version 6: site address changed, contact position removed
  let(:version_six) { File.read("./spec/fixtures/files/versions/registration/v1_6.json") }
  # version 7: contact name changed, contact position added
  let(:version_seven) { File.read("./spec/fixtures/files/versions/registration/v1_7.json") }
  # version 8: contact address removed, site grid reference added, applicant first name changed
  let(:version_eight) { File.read("./spec/fixtures/files/versions/registration/v1_8.json") }
  # version 9: contact address added
  let(:version_nine) { File.read("./spec/fixtures/files/versions/registration/v1_9.json") }

  describe "#run" do
    context "when it processes the diff between the two versions" do
      context "with registration field changes" do
        it "contains updates" do
          expected_output = [
            ["~", "addresses.operator", "ENVIRONMENT AGENCY\nHORIZON HOUSE\nDEANERY ROAD\nBRISTOL\nBS1 5AH", "THRIVE RENEWABLES PLC\nDEANERY ROAD\nBRISTOL\nBS1 5AH"],
            ["~", "applicant_first_name", "Fname", "name"],
            ["~", "applicant_last_name", "Sname", "name"],
            ["~", "contact_position", "Manager", "Director"]
          ]
          expect(service.run(older_version_json: version_four, newer_version_json: version_five)).to eq(expected_output)
        end

        it "contains removals" do
          expected_output = [
            ["-", "addresses.site", "ST 58132 72695\ndwdwad", ""],
            ["-", "contact_position", "Director", ""]
          ]
          expect(service.run(older_version_json: version_five, newer_version_json: version_six)).to eq(expected_output)
        end

        it "contains additions" do
          expected_output = [
            ["~", "contact_first_name", "Fnam", "Fname"],
            ["~", "contact_last_name", "Snam", "Sname"],
            ["+", "contact_position", "", "Consultant"]
          ]
          expect(service.run(older_version_json: version_six, newer_version_json: version_seven)).to eq(expected_output)
        end
      end

      context "with registration address changes" do
        it "contains updates" do
          expected_output = [
            ["~", "addresses.operator", "ENVIRONMENT AGENCY\nHORIZON HOUSE\nDEANERY ROAD\nBRISTOL\nBS1 5AH", "THRIVE RENEWABLES PLC\nDEANERY ROAD\nBRISTOL\nBS1 5AH"],
            ["~", "applicant_first_name", "Fname", "name"],
            ["~", "applicant_last_name", "Sname", "name"],
            ["~", "contact_position", "Manager", "Director"]
          ]
          expect(service.run(older_version_json: version_four, newer_version_json: version_five)).to eq(expected_output)
        end

        it "contains removals" do
          expected_output = [
            ["-", "addresses.contact", "ENVIRONMENT AGENCY\nHORIZON HOUSE\nDEANERY ROAD\nBRISTOL\nBS1 5AH", ""],
            ["+", "addresses.site", "", "ST 58132 72694\ngrid ref"],
            ["~", "applicant_first_name", "name", "names"]
          ]
          expect(service.run(older_version_json: version_seven, newer_version_json: version_eight)).to eq(expected_output)
        end

        it "contains additions" do
          expected_output = [
            ["+", "addresses.contact", "", "ENVIRONMENT AGENCY\nHORIZON HOUSE\nBRISTOL\nBS1 5AH"]
          ]
          expect(service.run(older_version_json: version_eight, newer_version_json: version_nine)).to eq(expected_output)
        end
      end
    end
  end
end
