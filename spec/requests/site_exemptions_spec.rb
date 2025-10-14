# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Site Exemptions" do
  let(:user) { create(:user, :admin_team_lead) }

  before { sign_in(user) }

  describe "GET /registrations/:reference/sites/:site_id/exemptions" do
    subject(:request_site_exemptions) do
      get registration_site_exemptions_path(registration_reference: registration.reference, site_id: site.id)
    end

    let(:registration) { create(:registration, registration_exemptions: []) }
    let(:site) do
      registration.site_addresses.first || create(:address, :site, registration: registration)
    end

    shared_examples "renders the index template with a 200 response" do
      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:index) }
    end

    shared_examples "displays the selected site's heading" do
      it {
        expect(response.body).to include(
          I18n.t("site_exemptions.index.heading", grid_reference_or_address: site.grid_reference)
        )
      }
    end

    context "when the site has exemptions" do
      let!(:site_registration_exemptions) do
        [
          create(
            :registration_exemption,
            :active,
            registration: registration,
            address: site,
            created_at: 2.days.ago.beginning_of_day,
            expires_on: 1.year.from_now.to_date
          ),
          create(
            :registration_exemption,
            :ceased,
            registration: registration,
            address: site,
            created_at: 1.day.ago.beginning_of_day,
            expires_on: 6.months.from_now.to_date
          )
        ]
      end
      let!(:other_site) { create(:address, :site, registration: registration) }
      let!(:other_registration_exemption) do
        create(:registration_exemption, :revoked, registration: registration, address: other_site)
      end

      before { request_site_exemptions }

      it_behaves_like "renders the index template with a 200 response"
      it_behaves_like "displays the selected site's heading"

      it "assigns the exemptions for only the requested site" do
        expect(assigns(:site_registration_exemptions)).to match_array(site_registration_exemptions)
      end

      it "lists the registration exemptions for the site" do
        site_registration_exemptions.each do |registration_exemption|
          exemption = registration_exemption.exemption
          formatted_registered_on = registration_exemption.registered_on.strftime("%-d %B %Y")
          formatted_expires_on = registration_exemption.expires_on.strftime("%-d %B %Y")

          expect(response.body).to include("#{exemption.code} &mdash; #{exemption.summary}")
          expect(response.body).to include(formatted_registered_on)
          expect(response.body).to include(formatted_expires_on)
          expect(response.body).to include(registration_exemption.state)
        end
      end

      it "includes the expected action links based on exemption state" do
        expect(response.body).to include("Deregister")
        expect(response.body).to include("Details")
      end

      it "does not display exemptions for other sites" do
        expect(response.body).not_to include(other_registration_exemption.exemption.code)
      end
    end

    context "when the site has no exemptions" do
      before { request_site_exemptions }

      it_behaves_like "renders the index template with a 200 response"
      it_behaves_like "displays the selected site's heading"

      it "assigns an empty collection for the site exemptions" do
        expect(assigns(:site_registration_exemptions)).to be_empty
      end

      it "shows a message indicating there are no exemptions" do
        expect(response.body).to include(I18n.t("site_exemptions.index.no_exemptions"))
      end

      it "does not list any exemptions" do
        expect(response.body).not_to include("Deregister")
        expect(response.body).not_to include("Details")
      end
    end
  end
end
