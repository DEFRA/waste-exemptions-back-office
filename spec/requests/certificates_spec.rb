# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Certificates" do
  let(:registration) { create(:registration) }
  let(:user) { create(:user, role: :customer_service_adviser) }

  before do
    sign_in(user)
  end

  describe "GET /bo/registrations/:reference/certificate/" do
    it "responds with a PDF with a filename that includes the registration reference and returns a 200 status code" do
      get "/registrations/#{registration.reference}/certificate"

      expect(response.media_type).to eq("application/pdf")
      expected_content_disposition = "inline; filename=\"#{registration.reference}.pdf\"; filename*=UTF-8''#{registration.reference}.pdf"
      expect(response.headers["Content-Disposition"]).to eq(expected_content_disposition)
      expect(response).to have_http_status(:ok)
    end

    context "when the 'show_as_html' query string is present" do
      context "when the value is 'true'" do
        it "responds with HTML" do
          get "/registrations/#{registration.reference}/certificate?show_as_html=true"

          expect(response.media_type).to eq("text/html")
        end
      end

      [false, 1, 0, :foo].each do |bad_value|
        context "when the value is '#{bad_value}'" do
          it "responds with a PDF" do
            get "/registrations/#{registration.reference}/certificate?show_as_html=#{bad_value}"

            expect(response.media_type).to eq("application/pdf")
          end
        end
      end
    end
  end
end
