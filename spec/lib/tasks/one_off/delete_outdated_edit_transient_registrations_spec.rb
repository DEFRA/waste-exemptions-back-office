# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "one_off:delete_outdate_edit_transient_registrations", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:delete_outdated_edit_transient_registrations"] }

  let(:registration) { create(:registration) }

  before do
    # Use raw SQL to bypass STI mechanism and insert data that imitates a deprecated transient registration
    ActiveRecord::Base.connection.execute(
      <<-SQL.squish
        INSERT INTO transient_registrations
          (type, reference, created_at, updated_at)
        VALUES
          ('WasteExemptionsEngine::EditRegistration', '#{registration.reference}', NOW(), NOW());
      SQL
    )
  end

  after { rake_task.reenable }

  it "deletes all transient registrations of type 'WasteExemptionsEngine::EditRegistration'" do
    expect do
      rake_task.invoke
    end.to change {
      ActiveRecord::Base.connection.execute(
        "SELECT COUNT(*) FROM transient_registrations WHERE type = 'WasteExemptionsEngine::EditRegistration'"
      ).first["count"]
    }.from(1).to(0)
  end
end
