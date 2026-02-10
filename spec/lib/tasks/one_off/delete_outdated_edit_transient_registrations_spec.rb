# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "one_off:delete_outdate_edit_transient_registrations", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:delete_outdated_edit_transient_registrations"] }

  let(:registration) { create(:registration) }

  before do
    # Use raw SQL to bypass STI mechanism and insert data that imitates a deprecated transient registration
    ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        INSERT INTO transient_registrations
          (type, reference, created_at, updated_at)
        VALUES
          ('WasteExemptionsEngine::EditRegistration', '#{registration.reference}', NOW(), NOW());
      SQL
    )

    transient_registration_id = ActiveRecord::Base.connection.execute(
      "SELECT id FROM transient_registrations WHERE type = 'WasteExemptionsEngine::EditRegistration'"
    ).first["id"]
    create(:transient_address, transient_registration_id: transient_registration_id)
    create(:transient_person, transient_registration_id: transient_registration_id)
    create(:transient_registration_exemption, transient_registration_id: transient_registration_id)
  end

  after { rake_task.reenable }

  it "deletes all transient registrations of type 'WasteExemptionsEngine::EditRegistration'" do
    expect do
      rake_task.invoke
    end.to change {
      {
        transient_addresses: WasteExemptionsEngine::TransientAddress.count,
        transient_people: WasteExemptionsEngine::TransientPerson.count,
        transient_registration_exemptions: WasteExemptionsEngine::TransientRegistrationExemption.count,
        transient_registrations: ActiveRecord::Base.connection.execute(
          "SELECT COUNT(*) FROM transient_registrations WHERE type = 'WasteExemptionsEngine::EditRegistration'"
        ).first["count"]
      }
    }.from(a_hash_including(
             transient_addresses: 1,
             transient_people: 1,
             transient_registration_exemptions: 1,
             transient_registrations: 1
           )).to(a_hash_including(
                   transient_addresses: 0,
                   transient_people: 0,
                   transient_registration_exemptions: 0,
                   transient_registrations: 0
                 ))
  end
end
