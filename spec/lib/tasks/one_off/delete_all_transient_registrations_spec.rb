# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "one_off:delete_all_transient_registrations", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:delete_all_transient_registrations"] }

  let(:registration) { create(:registration) }

  before do
    create_list(:back_office_edit_registration, 3)
    create_list(:new_charged_registration, 2)
    create_list(:renewing_registration, 5)
  end

  after { rake_task.reenable }

  it "deletes all transient registrations" do
    expect do
      rake_task.invoke
    end.to change(WasteExemptionsEngine::TransientRegistration, :count).from(10).to(0)
  end
end
