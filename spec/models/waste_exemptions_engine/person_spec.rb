# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Person do
  let(:matching_person) { create(:person) }
  let(:non_matching_person) { create(:person) }

  describe "#search_for_name" do
    let(:term) { nil }
    let(:scope) { described_class.search_for_name(term) }

    context "when the search term is a first_name" do
      let(:term) { matching_person.first_name }

      it "returns people with a matching name" do
        expect(scope).to include(matching_person)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_person)
      end
    end

    context "when the search term is a last_name" do
      let(:term) { matching_person.last_name }

      it "returns people with a matching name" do
        expect(scope).to include(matching_person)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_person)
      end
    end

    context "when the search term is a full name" do
      let(:term) { "#{matching_person.first_name} #{matching_person.last_name}" }

      it "returns people with a matching name" do
        expect(scope).to include(matching_person)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_person)
      end
    end
  end
end
