# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommandLineTableFormatter do
  subject(:rendered) { described_class.new(rows).render }

  describe "#render" do
    context "with several rows" do
      let(:rows) do
        [{ "ID" => 1, "Status" => "active" },
         { "ID" => 42, "Status" => "no_exemptions" }]
      end

      it "uses the hash keys as the header row" do
        expect(rendered.lines.first.chomp).to eq("ID  Status")
      end

      it "renders a dashed separator sized to each column" do
        expect(rendered.lines[1].chomp).to eq("--  -------------")
      end

      it "left-aligns each column to the width of its widest value" do
        expect(rendered.lines[2].chomp).to eq("1   active")
        expect(rendered.lines[3].chomp).to eq("42  no_exemptions")
      end

      it "stringifies non-string values" do
        expect(rendered).to include("42")
      end

      it "does not leave trailing whitespace on any line" do
        expect(rendered.lines).to all(satisfy { |line| line.chomp == line.chomp.rstrip })
      end
    end

    context "with a single hash" do
      let(:rows) { { "ID" => 7, "Status" => "ceased" } }

      it "renders it as a one-row table" do
        expect(rendered.lines.map(&:chomp)).to eq(["ID  Status", "--  ------", "7   ceased"])
      end
    end

    context "with no rows" do
      let(:rows) { [] }

      it "returns an empty string" do
        expect(rendered).to eq("")
      end
    end
  end
end
