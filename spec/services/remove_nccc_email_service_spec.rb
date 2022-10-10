# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemoveNcccEmailService do
  subject(:service) { described_class.run }

  let(:registration) { create(:registration, applicant_email: applicant_email, contact_email: contact_email) }

  describe ".run" do
    shared_examples "removes contact email" do
      it "removes the contact email" do
        expect { service }.to change { registration.reload.contact_email }.to(nil)
      end
    end

    shared_examples "removes applicant email" do
      it "removes the applicant email" do
        expect { service }.to change { registration.reload.applicant_email }.to(nil)
      end
    end

    context "with a waste exemptions email address" do
      let(:contact_email) { "waste-exemptions@environment-agency.gov.uk" }
      let(:applicant_email) { "waste-exemptions@environment-agency.gov.uk" }

      it_behaves_like "removes contact email"
      it_behaves_like "removes applicant email"
    end

    context "with an nccc email address" do
      let(:applicant_email) { "nccc-carrierbroker@environment-agency.gov.uk" }
      let(:contact_email) { "nccc-carrierbroker@environment-agency.gov.uk" }

      it_behaves_like "removes contact email"
      it_behaves_like "removes applicant email"
    end

    context "with nccc typos" do
      let(:applicant_email) { "nccc-wasteexemptions@environment-agency.gov.uk" }
      let(:contact_email) { "nccc-wasteexemptions@environment-agency.gov.uk" }

      it_behaves_like "removes contact email"
      it_behaves_like "removes applicant email"
    end

    context "with waste exemptions typos in username" do
      let(:applicant_email) { "wqexemptions@environment-agency.gov.uk" }
      let(:contact_email) { "wqexemptions@environment-agency.gov.uk" }

      it_behaves_like "removes contact email"
      it_behaves_like "removes applicant email"
    end

    context "with waste exemptions email typos in domain name" do
      let(:applicant_email) { "waste-exemptions@environmentagency.gov.uk" }
      let(:contact_email) { "waste-exemptions@environmentagency.gov.uk" }

      it_behaves_like "removes contact email"
      it_behaves_like "removes applicant email"
    end

    context "with waste exemptions capitalised" do
      let(:applicant_email) { "WASTE-exemptions@environmentagency.gov.uk" }
      let(:contact_email) { "waste-EXEMPTIONS@EnViRoNmentagency.gov.uk" }

      it_behaves_like "removes contact email"
      it_behaves_like "removes applicant email"
    end

    context "with an email starting with exemptions" do
      let(:applicant_email) { "excemptions@environment-agency.gov.uk" }
      let(:contact_email) { "exceptions@environment-agency.gov.uk" }

      it_behaves_like "removes contact email"
      it_behaves_like "removes applicant email"
    end

    context "with personal environment agency email as contact and applicant emails" do
      let(:applicant_email) { "#{Faker::Name.first_name}.#{Faker::Name.last_name}@environment-agency.gov.uk" }
      let(:contact_email) { "#{Faker::Name.first_name}.#{Faker::Name.last_name}@environment-agency.gov.uk" }

      it "does not remove the contact email" do
        expect { service }.not_to change(registration, :contact_email)
      end

      it "does not remove the applicant email" do
        expect { service }.not_to change(registration, :applicant_email)
      end
    end

    context "with non-environment agency applicant and contact emails" do
      let(:applicant_email) { Faker::Internet.email }
      let(:contact_email) { Faker::Internet.email }

      it "does not remove the applicant email" do
        expect { service }.not_to change(registration, :applicant_email)
      end

      it "does not remove the contact email" do
        expect { service }.not_to change(registration, :contact_email)
      end
    end
  end
end
