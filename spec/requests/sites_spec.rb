# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sites" do
  let(:user) { create(:user, role: :customer_service_adviser) }

  before { sign_in(user) }

  shared_examples "renders the index template and returns a 200 response" do
    before { get "/registrations/#{registration.reference}/sites" }

    it { expect(response).to render_template(:index) }
    it { expect(response).to have_http_status(:ok) }
  end

  shared_examples "includes the correct content" do
    before { get "/registrations/#{registration.reference}/sites" }

    it { expect(response.body).to include("Waste operation sites") }
    it { expect(response.body).to include(site_address.reference) }
    it { expect(response.body).to include(site_address.grid_reference) }
    it { expect(response.body).to include(site_address.description) }
    it { expect(response.body).to include(site_address.area.to_s) }
    it { expect(response.body).to include(site_address.site_status) }
    it { expect(response.body).to include(site_address.ceased_or_revoked_exemptions) }
  end

  describe "GET /bo/registrations/:reference/sites/" do
    context "when registration is single-site" do
      let(:registration) { create(:registration) }
      let(:site_address) { create(:address, :site, registration: registration) }

      it_behaves_like "renders the index template and returns a 200 response"
      it_behaves_like "includes the correct content"
    end

    context "when registration is multi-site" do
      let(:registration) { create(:registration, :multisite) }
      let(:site_address) { create(:address, :site, registration: registration) }
      let(:site_address_two) { create(:address, :site, registration: registration) }

      it_behaves_like "renders the index template and returns a 200 response"
      it_behaves_like "includes the correct content"

      it "paginates the results" do
        registration = create(:registration, :multisite, addresses: [])
        create_list(:address, 25, :site, registration: registration)

        get "/registrations/#{registration.reference}/sites"

        expect(response.body).to include("Waste operation sites")
        expect(response.body).to include("Showing 1 &ndash; 20 of 25 results")
        expect(response.body).to include("Next")
        expect(response.body).not_to include("Previous")

        get "/registrations/#{registration.reference}/sites?page=2"

        expect(response.body).to include("Waste operation sites")
        expect(response.body).to include("Showing 21 &ndash; 25 of 25 results")
        expect(response.body).not_to include("Next")
        expect(response.body).to include("Previous")
      end
    end
  end
end
