# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bulk Exports" do
  let(:user) { create(:user, :system) }

  before do
    sign_in(user)
  end

  describe "GET /data-exports" do
    before do
      create(:generated_report, created_at: Time.zone.local(2019, 6, 1, 12, 0), data_from_date: Date.new(2019, 6, 1))
    end

    it "renders the correct template, the timestamp in an accessible format and responds with a 200 status code" do
      # The 2 in "12:00pm" is optional to allow for changes in daylight savings - 12:00pm or 1:00pm is valid
      export_at_regex = /These files were created at 12?:00pm on 1 June 2019\./m

      get bulk_exports_path

      expect(response).to render_template("bulk_exports/show")
      expect(response.body.scan(export_at_regex).count).to eq(1)
      expect(response).to have_http_status(:ok)
    end
  end
end
