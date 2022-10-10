# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchService do

  # Use let! to ensure all test model instances are in the DB even if not exlicitly referenced in the examples
  let!(:registration) { create(:registration) }

  let(:model) { nil }

  let(:results) do
    service = described_class.new
    service.search(term, model, 1)
  end

  context "when a search term is provided" do
    context "when the model is set to registrations" do
      let(:model) { :registrations }
      let!(:other_registration) { create(:registration) }

      shared_examples "registration matches and non-matches" do
        it "returns matching registrations" do
          expect(results).to include(registration)
        end

        it "does not return non-matching registrations" do
          expect(results).not_to include(other_registration)
        end
      end

      context "with matches on reference" do
        let(:term) { registration.reference }

        it_behaves_like "registration matches and non-matches"
      end

      context "with matches on contact_phone" do
        let(:term) { registration.contact_phone }

        it_behaves_like "registration matches and non-matches"
      end

      context "with no matches on any attribute" do
        let(:term) { "this search term does not match any model attribute" }

        it "does not return any matches" do
          expect(results).to be_empty
        end
      end
    end

    context "when the model is set to new_registrations" do
      let(:model) { :new_registrations }
      let!(:new_registration) { create(:new_registration) }
      let!(:other_new_registration) { create(:new_registration) }

      shared_examples "new_registration matches and non-matches" do
        it "returns matching new_registrations" do
          expect(results).to include(new_registration)
        end

        it "does not return non-matching new_registrations" do
          expect(results).not_to include(other_new_registration)
        end
      end

      context "with matches on applicant_first_name" do
        let(:term) { new_registration.applicant_first_name }

        it_behaves_like "new_registration matches and non-matches"
      end

      context "with matches on contact_phone" do
        let(:term) { new_registration.contact_phone }

        it_behaves_like "new_registration matches and non-matches"
      end

      context "with no matches on any attribute" do
        let(:term) { "this search term does not match any model attribute" }

        it "does not return any matches" do
          expect(results).to be_empty
        end
      end
    end

    context "when the search term has excess whitespace" do
      let(:term) { "  foo  " }

      it "ignores the whitespace when searching" do
        allow(WasteExemptionsEngine::Registration).to receive(:search_registration_and_relations)

        results

        expect(WasteExemptionsEngine::Registration).to have_received(:search_registration_and_relations).with("foo")
      end
    end
  end

  context "when no search term is provided" do
    let(:term) { nil }

    it "returns no results" do
      expect(results.length).to eq(0)
    end
  end
end
