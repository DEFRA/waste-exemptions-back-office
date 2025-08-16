# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Registration do
  subject(:registration) { build(:registration) }

  let(:matching_registration) { create(:registration) }
  let(:non_matching_registration) { create(:registration) }

  describe ".renewals" do
    it "returns registrations that are renewals of older registrations" do
      registration = create(:registration)
      renewal = create(:registration, referring_registration: registration)

      result = described_class.renewals

      expect(result).to include(renewal)
      expect(result).not_to include(registration)
    end
  end

  describe ".contact_email_present" do
    let(:registration) { create(:registration) }

    it "returns registrations that don't have a blank contact email" do
      registration.update(contact_email: "test@example.com")

      result = described_class.contact_email_present

      expect(result).to include(registration)
    end

    it "does not return registrations that do have a blank contact email" do
      registration.update(contact_email: nil)

      result = described_class.contact_email_present

      expect(result).not_to include(registration)
    end
  end

  describe ".site_address_is_not_nccc" do
    let(:registration) { create(:registration, :site_uses_address) }

    it "returns registrations that don't have the NCCC postcode in the site address" do
      registration.site_address.update(postcode: "AA1 1AA")

      result = described_class.site_address_is_not_nccc

      expect(result).to include(registration)
    end

    it "does not return registrations that do have the NCCC postcode in the site address" do
      registration.site_address.update(postcode: "S9 4WF")

      result = described_class.site_address_is_not_nccc

      expect(result).not_to include(registration)
    end
  end

  describe "#renewable?" do

    before do
      allow(WasteExemptionsEngine.configuration)
        .to receive_messages(renewal_window_before_expiry_in_days: 28, renewal_window_after_expiry_in_days: 30)
    end

    let(:registration_exemption) { build(:registration_exemption, expires_on: expires_on, state: state) }
    let(:registration) { create(:registration, registration_exemptions: [registration_exemption]) }

    context "when the registration is in a renewal window and renewal state" do
      let(:expires_on) { 10.days.from_now }
      let(:state) { "active" }

      it "returns true" do
        expect(registration).to be_renewable
      end
    end

    context "when the registration is not in a renewal window" do
      let(:expires_on) { 50.days.from_now }
      let(:state) { "active" }

      it "returns false" do
        expect(registration).not_to be_renewable
      end
    end

    context "when the registration is not in a renewal state" do
      let(:expires_on) { 10.days.from_now }
      let(:state) { "ceased" }

      it "returns false" do
        expect(registration).not_to be_renewable
      end
    end
  end

  describe "#in_renewable_state?" do

    let(:registration_exemption) { build(:registration_exemption, state: state) }
    let(:registration) { create(:registration, registration_exemptions: [registration_exemption]) }

    before do
      allow(registration).to receive(:state).and_return(state)
    end

    context "when the state is active" do
      let(:state) { "active" }

      it "returns true" do
        expect(registration).to be_in_renewable_state
      end
    end

    context "when the state is expired" do
      let(:state) { "expired" }

      it "returns true" do
        expect(registration).to be_in_renewable_state
      end
    end

    context "when the state is not expired nor active" do
      let(:state) { "ceased" }

      it "returns false" do
        expect(registration).not_to be_in_renewable_state
      end
    end
  end

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

      context "when the address is an operator address" do
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
      let(:matching_registration) { create(:registration, :partnership) }
      let(:non_matching_registration) { create(:registration, :partnership) }
      let(:term) do
        person = matching_registration.people.first
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

  describe "#active?" do

    let(:registration_exemption) { build(:registration_exemption, state: exemption_state) }
    let(:registration) { create(:registration, registration_exemptions: [registration_exemption]) }

    context "when the state is :active" do
      let(:exemption_state) { "active" }

      it "returns `true`" do
        expect(registration.active?).to be true
      end
    end

    %w[ceased revoked expired].each do |state|
      context "when the state is :#{state}" do

        let(:exemption_state) { state }

        it "returns `false`" do
          expect(registration.active?).to be false
        end
      end
    end
  end

  describe "#state" do
    %w[active ceased revoked expired].each do |state|
      context "when all of the registration's exemption registrations are #{state}" do
        let(:registration) do
          registration = create(:registration)
          registration.registration_exemptions.each do |re|
            re.state = state
            re.save!
          end
          registration
        end

        it "returns \"#{state}\"" do
          expect(registration.state).to eq state
        end
      end
    end

    context "when the registration's exemption registrations have mixed states" do
      subject(:registration) { create(:registration, registration_exemptions: registration_exemptions) }

      context "when at least one exemption is in an active status" do
        let(:registration_exemptions) do
          [
            build(:registration_exemption, :active),
            build(:registration_exemption, :revoked)
          ]
        end

        it "returns active status" do
          expect(registration.state).to eq("active")
        end
      end

      context "when no exemption in the registration is still active" do
        let(:registration_exemptions) do
          [
            build(:registration_exemption, :revoked),
            build(:registration_exemption, :ceased)
          ]
        end

        context "when at least one exemption is in a revoked status" do
          it "returns revoked status" do
            expect(registration.state).to eq("revoked")
          end
        end

        context "when no exemption is in a revoked status" do
          let(:registration_exemptions) do
            [
              build(:registration_exemption, :expired),
              build(:registration_exemption, :ceased)
            ]
          end

          context "when at least one exemption is in a expired status" do
            it "returns expired status" do
              expect(registration.state).to eq("expired")
            end
          end

          context "when no exemption is in a expired status" do
            let(:registration_exemptions) do
              [
                build(:registration_exemption, :ceased),
                build(:registration_exemption, :ceased)
              ]
            end

            it "returns ceased status" do
              expect(registration.state).to eq("ceased")
            end
          end
        end
      end
    end
  end

  shared_context "free renewals" do
    let!(:t28_exemption) { create(:exemption, code: "T28") }

    let!(:charity_registration) { create(:registration, :charity) }
    let!(:non_charity_registration) { create(:registration, :partnership) }
    
    let!(:t28_only_registration) do
      create(:registration, registration_exemptions: [
        build(:registration_exemption, exemption: t28_exemption)
      ])
    end
    let!(:t28_plus_registration) do
      create(:registration, registration_exemptions: [
        build(:registration_exemption, exemption: t28_exemption),
        build(:registration_exemption)
      ])
    end
    let!(:non_t28_registration) do
      create(:registration, registration_exemptions: [
        build(:registration_exemption)
      ])
    end
  end

  describe "#charity" do
    include_context "free renewals"

    it { expect(described_class.charity).to include(charity_registration) }
    it { expect(described_class.charity).not_to include(non_charity_registration) }
  end

  describe "#with_exemption" do
    include_context "free renewals"

    it { expect(described_class.with_exemption("T28")).to include(t28_only_registration) }
    it { expect(described_class.with_exemption("T28")).to include(t28_plus_registration) }
    it { expect(described_class.with_exemption("T28")).not_to include(non_t28_registration) }
  end

  describe "#eligible_for_free_renewal" do
    include_context "free renewals"

    it { expect(described_class.eligible_for_free_renewal).to include(charity_registration) }
    it { expect(described_class.eligible_for_free_renewal).to include(t28_only_registration) }
    it { expect(described_class.eligible_for_free_renewal).to include(t28_plus_registration) }
    it { expect(described_class.eligible_for_free_renewal).not_to include(non_charity_registration) }
    it { expect(described_class.eligible_for_free_renewal).not_to include(non_t28_registration) }
  end
end
