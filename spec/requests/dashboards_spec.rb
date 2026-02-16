# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards" do
  describe "/" do
    let(:results) { Kaminari.paginate_array([]).page(1) }

    context "when a valid user is signed in" do
      # rubocop:disable RSpec/AnyInstance
      before do
        sign_in(create(:user))
        # Stub the service to reduce database hits
        allow_any_instance_of(SearchService).to receive(:search).and_return(results)
      end
      # rubocop:enable RSpec/AnyInstance

      it "renders the index template and returns a 200 response" do
        get "/"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end

      it "shows the updated search hint text" do
        get "/"

        expect(response.body.squish).to include("You can search for a registration by: postcodes, registration reference number, business or partner name, contact name, telephone number, and contact email")
      end

      # rubocop:disable RSpec/AnyInstance
      context "when there is a term, a filter and a page" do
        it "calls a SearchService with the correct params" do
          expect_any_instance_of(SearchService).to receive(:search).with("foo", :registrations, "2")

          get "/", params: { term: "foo", filter: "registrations", page: "2" }
        end
      end
      # rubocop:enable RSpec/AnyInstance

      context "when the SearchService does not return results" do
        it "says there are no results" do
          get "/", params: { term: "foo" }

          expect(response.body).to include("No results")
        end
      end

      context "when the SearchService returns one registration and one transient registration" do
        let(:registration) { create(:registration) }
        let(:new_registration) { create(:new_charged_registration) }
        let(:results) { Kaminari.paginate_array([registration, new_registration]).page(1) }
        let(:search_terms) { { term: "foo" } }

        it "lists the results" do
          get "/", params: search_terms

          expect(response.body).to include(registration.reference)

          # a transient registration does not have a reference
          expect(response.body).to include("not yet submitted")
        end

        it "persists search terms in the registration link" do
          get "/", params: search_terms

          reg_path = registration_path(reference: registration.reference, term: search_terms[:term])
          expect(response.body).to include(reg_path)
        end

        it "does not show applicant details in the search results" do
          get "/", params: search_terms

          expect(response.body).not_to include("Applicant")
          expect(response.body).not_to include("#{registration.applicant_first_name} #{registration.applicant_last_name}")
        end
      end
    end

    context "when a deactivated user is signed in" do
      before { sign_in(create(:user, :inactive)) }

      it "redirects to the deactivated page" do
        get "/"

        expect(response).to redirect_to("/pages/deactivated")
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
