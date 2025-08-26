# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationChangeHistoryService do
  shared_examples "includes the correct changes" do |changed, reason_for_change, changed_by|
    let(:service_response) { described_class.run(registration) }

    it "includes the correct date" do
      expect(service_response.last[:date]).to eq(registration.versions.last.created_at)
    end

    it "includes the correct changed values" do
      changed.each do |change|
        expect(service_response.last[:changed]).to include(change)
      end
    end

    it "includes the correct reason_for_change value" do
      expect(service_response.last[:reason_for_change]).to eq(reason_for_change)
    end

    it "includes the correct changed_by value" do
      expect(service_response.last[:changed_by]).to eq(changed_by)
    end

    it "excludes updated_at and reason_for_change from the changesets" do
      expect(service_response.last[:changed].pluck(1)).not_to include("updated_at", "reason_for_change")
    end
  end

  describe ".run", :versioning do
    let(:user) { create(:user, email: "developer@wex.gov.uk") }
    let(:registration) do
      reg = build(:registration, placeholder: true)
      # 1st version
      reg.save(validate: false)
      # 2nd version
      # the reference gets set automatically by the system
      # fter the registration is created
      # 3rd version
      reg.update(contact_first_name: "Johnny", contact_last_name: "Smiths", contact_position: "Manager", reason_for_change: "Fixing the typo in name")
      # 4th version
      reg.update(contact_first_name: "John", contact_last_name: "Smith", contact_position: "Senior Manager", reason_for_change: "Fixing the typo in name")
      reg
    end
    let(:service_response) { described_class.run(registration) }

    it "has PaperTrail" do
      expect(PaperTrail).to be_enabled
    end

    it "is versioned" do
      expect(registration).to be_versioned
    end

    it "returns an array of changes for each version" do
      aggregate_failures do
        expect(service_response).to be_an(Array)
        expect(service_response.length).to be > 0
      end
    end

    context "when placeholder is present (newer registrations)" do
      it "excludes versions before the placeholder change" do
        expect(service_response.length).to eq(2)
        expect(service_response[0][:changed][0][1]).not_to eq(%w[reference applicant_first_name])
        expect(service_response[1][:changed][0][1]).not_to eq(%w[reference applicant_first_name])
      end

      it "excludes versions with placeholder change" do
        expect(service_response.pluck(:changed)).not_to include(["~", "placeholder", true, false])
      end
    end

    context "when placeholder is not present (older registrations)" do
      let(:registration) do
        reg = build(:registration, placeholder: nil)
        # 1st version
        reg.save(validate: false)
        # 2nd version
        # the reference gets set automatically by the system
        # fter the registration is created
        # 3rd version
        reg.update(contact_first_name: "Johnny", contact_last_name: "Smiths", contact_position: "Manager", reason_for_change: "Fixing the typo in name")
        # 4th version
        reg.update(contact_first_name: "John", contact_last_name: "Smith", contact_position: "Senior Manager", reason_for_change: "Fixing the typo in name")
        reg
      end

      it "excludes first 2 versions" do
        changeset = service_response
        expect(service_response.length).to eq(2)
        expect(changeset[0][:changed][0][1]).to eq("contact_first_name")
      end
    end

    context "when several versions" do
      it "returns correct changes for the most recent version" do
        last = service_response.last

        aggregate_failures do
          expect(last[:date]).to be_present
          expect(last[:changed]).to include(
            ["~", "contact_first_name", "Johnny", "John"],
            ["~", "contact_last_name", "Smiths", "Smith"],
            ["~", "contact_position", "Manager", "Senior Manager"]
          )
        end
      end

      it "returns correct changes for the previous version" do
        first = service_response[0]

        aggregate_failures do
          expect(first[:date]).to be_present
          expect(first[:changed]).to include(
            ["~", "contact_first_name", a_string_matching(/^Firstcontact\d+$/), "Johnny"],
            ["~", "contact_last_name", a_string_matching(/^Lastcontact\d+$/), "Smiths"],
            ["+", "contact_position", "", "Manager"]
          )
        end
      end

      it "returns an empty array when there are no versions" do
        registration.versions.destroy_all

        expect(service_response).to eq([])
      end
    end

    describe "testing whodunnit" do
      it "displays Changed By correctly when whodunnit is nil" do
        PaperTrail.request.whodunnit = nil
        registration.update(contact_first_name: "Jane", reason_for_change: "Updating contact_first_name")

        expect(service_response.last[:changed_by]).to eq("System")
      end

      it "displays Changed By correctly when whodunnit is email address" do
        PaperTrail.request.whodunnit = "developer@wex.gov.uk"
        registration.update(contact_first_name: "Jane")
        expect(service_response.last[:changed_by]).to eq("developer@wex.gov.uk")
      end

      it "displays Changed By correctly when whodunnit is user id" do
        PaperTrail.request.whodunnit = user.id
        registration.update(contact_first_name: "Jane")

        expect(service_response.last[:changed_by]).to eq("developer@wex.gov.uk")
      end
    end

    context "when adjusting registration details" do
      it_behaves_like "includes the correct changes", [
        ["~", "contact_first_name", "Johnny", "John"],
        ["~", "contact_last_name", "Smiths", "Smith"],
        ["~", "contact_position", "Manager", "Senior Manager"]
      ], "Fixing the typo in name", "System"
    end

    context "when adjusting registration addresses" do
      before do
        # 5rd version - setting up operator address
        PaperTrail.request.whodunnit = "developer@wex.gov.uk"
        new_operator_address = create(:address, address_type: "operator", mode: "manual", premises: "Flat 12", street_address: "12 Malden road", city: "London", postcode: "BS1 2DF")
        registration.addresses = [new_operator_address, registration.site_address, registration.contact_address]
        registration.reason_for_change = "Adjusting operator address"
        registration.paper_trail.save_with_version
      end

      it_behaves_like "includes the correct changes", [
        ["+", "addresses.operator", "", "Flat 12\n12 Malden road\nLondon\nBS1 2DF"]
      ], "Adjusting operator address", "developer@wex.gov.uk"
    end

    context "when adjusting registration exemptions" do
      before do
        # 6rd version - extending expiry date
        PaperTrail.request.whodunnit = "developer@wex.gov.uk"
        registration.registration_exemptions.each do |re|
          re.update(expires_on: 4.years.from_now, reason_for_change: "Extending expiry date")
        end

        registration.paper_trail.save_with_version
      end

      it_behaves_like "includes the correct changes", [
        ["~", "registration_exemptions.expires_on", 3.years.from_now.to_date.to_fs(:year_month_day), 4.years.from_now.to_date.to_fs(:year_month_day)]
      ], "Extending expiry date", "developer@wex.gov.uk"
    end
  end
end
