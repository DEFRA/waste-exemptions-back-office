# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe RegistrationsSerializer do
      subject(:registrations_serializer) { described_class.new }

      it_behaves_like "A Boxi serializer"

      describe "#to_csv" do
        it "generates a csv file with data content" do
          create(:registration)

          result = registrations_serializer.to_csv
          result_lines = result.split("\n")

          expect(result_lines.first.split(",")).to include(*WasteExemptionsEngine::Registration.column_names)
          expect(result_lines.count).to eq(2)
        end
      end

      describe "#parse_assistance_mode" do
        context "for an unassisted registration" do
          it "returns 'Unassisted'" do
            expect(described_class.new.parse_assistance_mode(nil)).to eq("Unassisted")
          end
        end

        context "for a fully assisted registration" do
          it "returns 'Fully assisted'" do
            expect(described_class.new.parse_assistance_mode("full")).to eq("Fully assisted")
          end
        end

        context "for a partially assisted registration" do
          it "returns 'Partially assisted'" do
            expect(described_class.new.parse_assistance_mode("partial")).to eq("Partially assisted")
          end
        end

      end
    end
  end
end
