# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::NewChargedRegistration do
  let(:matching_registration) { create(:new_charged_registration) }
  let(:non_matching_registration) { create(:new_charged_registration) }

  describe "#search_registration_and_relations" do
    let(:term) { nil }
    let(:scope) { described_class.search_registration_and_relations(term) }

    context "when the search term is an applicant_email" do
      let(:term) { matching_registration.applicant_email }

      it "returns registrations with a matching reference" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end

      context "when the search term is in the wrong case" do
        let(:term) { matching_registration.applicant_email.upcase }

        it "still returns matching results" do
          expect(scope).to include(matching_registration)
        end
      end
    end

    context "when the search is a phone number" do
      context "when searching applicant number" do
        it_behaves_like "searching phone number attribute", :applicant_phone
      end

      context "when searching contact number" do
        it_behaves_like "searching phone number attribute", :contact_phone
      end
    end

    context "when the search term is an applicant_first_name" do
      let(:term) { matching_registration.applicant_first_name }

      it "returns registrations with a matching applicant name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an applicant_last_name" do
      let(:term) { matching_registration.applicant_last_name }

      it "returns registrations with a matching applicant name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an applicant's full name" do
      let(:term) { "#{matching_registration.applicant_first_name} #{matching_registration.applicant_last_name}" }

      it "returns registrations with a matching applicant name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an contact_email" do
      let(:term) { matching_registration.contact_email }

      it "returns registrations with a matching reference" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an contact_first_name" do
      let(:term) { matching_registration.contact_first_name }

      it "returns registrations with a matching contact name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an contact_last_name" do
      let(:term) { matching_registration.contact_last_name }

      it "returns registrations with a matching contact name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an contact's full name" do
      let(:term) { "#{matching_registration.contact_first_name} #{matching_registration.contact_last_name}" }

      it "returns registrations with a matching contact name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is an operator_name" do
      let(:term) { matching_registration.operator_name }

      it "returns registrations with a matching operator name" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end

      context "when the search term is a partial operator_name" do
        let(:term) { matching_registration.operator_name[0, 5] }

        it "returns registrations with a matching operator name" do
          expect(scope).to include(matching_registration)
        end
      end
    end

    context "when the search term is a reference" do
      let(:term) { matching_registration.reference }

      it "returns registrations with a matching reference" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is a related address's postcode" do
      context "when the address is a site address" do
        let(:site_address) { matching_registration.site_address }
        let(:term) { site_address.postcode }

        it "is included in the scope" do
          expect(scope).to include(matching_registration)
        end
      end

      context "when the address is a contact address" do
        let(:contact_address) { matching_registration.contact_address }
        let(:term) { contact_address.postcode }

        it "is included in the scope" do
          expect(scope).to include(matching_registration)
        end
      end

      context "when the address is a operator address" do
        let(:operator_address) { matching_registration.operator_address }
        let(:term) { operator_address.postcode }

        it "is included in the scope" do
          expect(scope).to include(matching_registration)
        end
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end

    context "when the search term is a related person's name" do
      let(:term) do
        person = matching_registration.transient_people.first
        "#{person.first_name} #{person.last_name}"
      end

      it "returns registrations with a matching person" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end
  end
end
