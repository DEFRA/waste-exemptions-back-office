# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationChangeHistoryService do
  describe ".run", :versioning do
    let(:user) { create(:user, email: "developer@wex.gov.uk") }
    let(:registration) { create(:registration) }
    let(:service_response) { described_class.run(registration) }

    before do
      PaperTrail.request.whodunnit = user.id

      # Create versions with changes

      # 2nd version
      registration.update(contact_first_name: "Johnny", contact_last_name: "Smiths", contact_position: "Manager")
      # 3rd version
      registration.update(contact_first_name: "John", contact_last_name: "Smith", contact_position: "Senior Manager", reason_for_change: "Fixing the typo in name")
    end

    it "has PaperTrail" do
      expect(PaperTrail).to be_enabled
    end

    it "is versioned" do
      expect(registration).to be_versioned
    end

    it "returns an array of changes for each version" do
      aggregate_failures do
        expect(service_response).to be_an(Array)
        expect(service_response.length).to eq(4)
      end
    end

    context "when several versions" do
      it "returns correct changes for the most recent version" do
        last = service_response.last

        aggregate_failures do
          expect(last[:date]).to be_present
          expect(last[:changed_to]).to include(
            { contact_first_name: "John" },
            { contact_last_name: "Smith" },
            { contact_position: "Senior Manager" }
          )
        end
      end

      it "returns correct changes for the previous version" do
        second = service_response[2]

        aggregate_failures do
          expect(second[:date]).to be_present
          expect(second[:changed_to]).to include(
            { contact_first_name: "Johnny" },
            { contact_last_name: "Smiths" },
            { contact_position: "Manager" }
          )
        end
      end

      it "returns correct changes for the oldest version" do
        first = service_response[1]

        aggregate_failures do
          expect(first[:date]).to be_present
          expect(first[:changed_to][0]).to include(:reference)
        end
      end
    end

    it "includes the correct date" do
      expect(service_response.last[:date]).to eq(registration.versions.last.created_at)
    end

    it "includes the correct changed_to values" do
      expect(service_response.last[:changed_to]).to include({ contact_first_name: "John" }, { contact_last_name: "Smith" }, { contact_position: "Senior Manager" })
    end

    it "includes the correct changed_from values" do
      expect(service_response.last[:changed_from]).to include({ contact_first_name: "Johnny" }, { contact_last_name: "Smiths" }, { contact_position: "Manager" })
    end

    it "includes the correct reason_for_change value" do
      expect(service_response.last[:reason_for_change]).to eq("Fixing the typo in name")
    end

    it "includes the correct changed_by value" do
      expect(service_response.last[:changed_by]).to eq("developer@wex.gov.uk")
    end

    it "displays Changed By correctly when whodunnit is nil" do
      PaperTrail.request.whodunnit = nil
      registration.update(contact_first_name: "Jane")

      expect(service_response.last[:changed_by]).to eq("System")
    end

    it "displays Changed By corretly when whodunnit is email address" do
      PaperTrail.request.whodunnit = "developer@wex.gov.uk"
      registration.update(contact_first_name: "Jane")

      expect(service_response.last[:changed_by]).to eq("developer@wex.gov.uk")
    end

    it "displays Changed By corretly when whodunnit is user id" do
      PaperTrail.request.whodunnit = user.id
      registration.update(contact_first_name: "Jane")

      expect(service_response.last[:changed_by]).to eq("developer@wex.gov.uk")
    end

    it "excludes updated_at and reason_for_change from the changesets" do
      expect(service_response.first[:changed_to]).not_to include(:updated_at, :reason_for_change)
      expect(service_response.first[:changed_from]).not_to include(:updated_at, :reason_for_change)
    end

    it "returns an empty array when there are no versions" do
      registration.versions.destroy_all

      expect(service_response).to eq([])
    end
  end
end
