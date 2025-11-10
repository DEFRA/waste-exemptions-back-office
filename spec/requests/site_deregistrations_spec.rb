# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SiteDeregistrations" do
  let(:registration) { create(:registration, :with_active_exemptions) }
  let(:site) { registration.site_addresses.first }

  describe "GET #show" do
    context "when a user is signed in" do
      before do
        sign_in(create(:user))
      end

      it "renders the show template and includes the site location" do
        get deregistrations_registration_site_path(registration_reference: registration.reference, id: site.id)

        expect(response).to render_template(:show)
        expect(response.body).to include("Deregistration details")
      end

      it "includes the correct back link" do
        get deregistrations_registration_site_path(registration_reference: registration.reference, id: site.id)

        expect(response.body).to include(registration_site_exemptions_path(registration.reference, site.id))
      end

      it "only shows deregistered exemptions for the site" do
        site_exemption = create(:registration_exemption, :revoked, registration: registration, address: site)

        other_site = create(:address, :site_address, registration: registration)
        other_exemption = create(:registration_exemption, :revoked, registration: registration, address: other_site)

        get deregistrations_registration_site_path(registration_reference: registration.reference, id: site.id)

        expect(response.body).to include(site_exemption.exemption.code)
        expect(response.body).not_to include(other_exemption.exemption.code)
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get deregistrations_registration_site_path(registration_reference: registration.reference, id: site.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
