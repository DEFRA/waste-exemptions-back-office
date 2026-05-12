# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditCompletionService do
  describe "run" do
    let(:edit_registration) { create(:edit_registration, :modified) }
    let(:registration) { edit_registration.registration }
    let(:skipped_attributes) do
      %w[
        registration_id
        transient_registration_id
        created_at
        updated_at
        id
      ]
    end
    let(:exemption_skipped_attributes) do
      skipped_attributes + %w[
        address_id
        transient_address_id
      ]
    end

    %w[
      applicant_email
      applicant_first_name
      applicant_last_name
      contact_email
      contact_first_name
      contact_last_name
      contact_phone
      contact_position
      operator_name
      is_a_farmer
      on_a_farm
    ].each do |attribute|
      it "updates the registration data for #{attribute}" do
        old_value = registration[attribute]
        new_value = edit_registration[attribute]

        expect { run_service }.to change {
          registration.reload[attribute]
        }.from(old_value).to(new_value)
      end
    end

    %i[operator_address contact_address].each do |address_type|
      it "copies the #{address_type} from the edit registration" do
        old_attributes = attributes_without_ids(registration.public_send(address_type))
        new_attributes = attributes_without_ids(edit_registration.public_send(address_type))

        expect { run_service }.to change {
          attributes_without_ids(registration.reload.public_send(address_type))
        }.from(old_attributes).to(new_attributes)
      end
    end

    context "when registration is single-site" do
      it "copies the site_address from the edit registration" do
        old_attributes = attributes_without_ids(registration.site_address)
        new_attributes = attributes_without_ids(edit_registration.site_address)

        expect { run_service }.to change {
          attributes_without_ids(registration.reload.site_address)
        }.from(old_attributes).to(new_attributes)
      end

      it "preserves the exemptions and ensures they match edit_registration" do
        expected_attributes = edit_registration.exemptions.map(&:attributes).map do |attrs|
          attrs.except(*exemption_skipped_attributes)
        end

        run_service

        actual_attributes = registration.reload.exemptions.map(&:attributes).map do |attrs|
          attrs.except(*exemption_skipped_attributes)
        end
        expect(actual_attributes).to eq(expected_attributes)
      end

      it "preserves deregistered exemption states after edit" do
        registration = create(:registration)
        ceased_exemption = registration.registration_exemptions.first
        ceased_exemption.update(state: "ceased", deregistered_at: Time.zone.today, deregistration_message: "Test message")

        edit_registration = EditRegistration.new(reference: registration.reference)
        edit_registration.save!
        edit_registration.update(contact_email: "new_email@example.com")

        described_class.run(edit_registration: edit_registration)

        final_exemption = registration.reload.registration_exemptions.find_by(exemption_id: ceased_exemption.exemption_id)
        expected = { state: "ceased", deregistered_at: Time.zone.today, deregistration_message: "Test message" }
        expect(final_exemption.slice(:state, :deregistered_at, :deregistration_message).symbolize_keys).to eq(expected)
      end
    end

    context "when registration is multi-site" do
      let(:edit_registration) { create(:edit_registration, :multisite, :modified) }

      it "preserves deregistered exemption states after edit" do
        registration = create(:registration, :multisite_complete)
        ceased_exemption = registration.site_addresses.first.registration_exemptions.first
        ceased_exemption.update(state: "ceased", deregistered_at: Time.zone.today, deregistration_message: "Test message")

        edit_registration = EditRegistration.new(reference: registration.reference)
        edit_registration.save!
        edit_registration.update(contact_email: "new_email@example.com")

        described_class.run(edit_registration: edit_registration)

        final_exemption = registration.reload.registration_exemptions.find_by(exemption_id: ceased_exemption.exemption_id)
        expected = { state: "ceased", deregistered_at: Time.zone.today, deregistration_message: "Test message" }
        expect(final_exemption.slice(:state, :deregistered_at, :deregistration_message).symbolize_keys).to eq(expected)
      end

      it "copies the site_addresses from the edit registration" do
        old_attributes = registration.site_addresses.map { |address| attributes_without_ids(address) }
        new_attributes = edit_registration.site_addresses.map { |address| attributes_without_ids(address) }

        expect { run_service }.to change {
          registration.reload.site_addresses.map { |address| attributes_without_ids(address) }
        }.from(old_attributes).to(new_attributes)
      end

      it "preserves the exemptions and ensures they match edit_registration" do
        expected_attributes = edit_registration.site_addresses.flat_map do |site_address|
          edit_registration.transient_registration_exemptions.where(transient_address_id: site_address.id).map(&:attributes).map do |attrs|
            attrs.except(*exemption_skipped_attributes)
          end
        end

        run_service

        actual_attributes = registration.reload.site_addresses.flat_map do |site_address|
          site_address.registration_exemptions.map(&:attributes).map do |attrs|
            attrs.except(*exemption_skipped_attributes)
          end
        end

        expect(actual_attributes.sort_by { |attrs| attrs["exemption_id"] }).to eq(expected_attributes.sort_by { |attrs| attrs["exemption_id"] })
      end
    end

    it "copies the people from the edit registration" do
      edit_registration = create(:edit_registration, :modified_people)
      registration = edit_registration.registration

      old_people_data = registration.people.map { |person| attributes_without_ids(person) }
      new_people_data = edit_registration.people.map { |person| attributes_without_ids(person) }

      expect { described_class.run(edit_registration: edit_registration) }.to change {
        registration.reload.people.map { |person| attributes_without_ids(person) }
      }.from(old_people_data).to(new_people_data)
    end

    it "removes no-longer-used attribute from the registration" do
      registration.update!(contact_position: "Manager")
      edit_registration.contact_position = nil
      old_value = registration.contact_position

      expect { run_service }.to change {
        registration.reload.contact_position
      }.from(old_value).to(nil)
    end

    it "deletes the edit_registration" do
      expect { run_service }.to change { EditRegistration.where(reference: edit_registration.reference).count }.by(-1)
    end

    it "deletes the edit_registration addresses" do
      edit_registration_id = EditRegistration.find_by(reference: edit_registration.reference).id

      expect { run_service }.to change { WasteExemptionsEngine::TransientAddress.where(transient_registration_id: edit_registration_id).count }.to(0)
    end

    it "deletes the edit_registration people" do
      edit_registration = create(:edit_registration, :with_people)
      edit_registration_id = EditRegistration.find_by(reference: edit_registration.reference).id

      expect do
        described_class.run(edit_registration: edit_registration)
      end.to change {
        WasteExemptionsEngine::TransientPerson.where(transient_registration_id: edit_registration_id).count
      }.to(0)
    end

    describe "PaperTrail", :versioning do
      it "creates a new version" do
        expect { run_service }.to change { registration.versions.count }.by(1)
      end

      it "includes the new data in the version JSON" do
        new_data = edit_registration.operator_name

        run_service

        expect(registration.reload.versions.last.json.to_s).to include(new_data)
      end

      context "when no data has changed" do
        let(:registration) { create(:registration) }
        let(:edit_registration) { EditRegistration.new(reference: registration.reference) }

        before do
          registration.site_address.update!(area: "Outside England")
          edit_registration.save!
        end

        it "does not create a new version" do
          expect { run_service }.not_to change { registration.versions.count }
        end
      end

      context "when only a related address's data has changed" do
        let(:edit_registration) { create(:edit_registration, :modified_addresses) }

        it "creates a new version" do
          expect { run_service }.to change { registration.versions.count }.by(1)
        end

        it "includes the new data in the version JSON" do
          new_data = edit_registration.contact_address.postcode

          run_service

          expect(registration.reload.versions.last.json.to_s).to include(new_data)
        end
      end

      context "when only a related person's data has changed" do
        let(:edit_registration) { create(:edit_registration, :modified_people) }

        it "creates a new version" do
          expect { run_service }.to change { registration.versions.count }.by(1)
        end

        it "includes the new data in the version JSON" do
          new_data = edit_registration.people.first.first_name

          run_service

          expect(registration.reload.versions.last.json.to_s).to include(new_data)
        end
      end
    end

    def run_service
      described_class.run(edit_registration: edit_registration)
    end

    def attributes_without_ids(record)
      record.attributes.except(*skipped_attributes)
    end
  end
end
