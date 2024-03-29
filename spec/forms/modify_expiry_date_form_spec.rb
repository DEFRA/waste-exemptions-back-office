# frozen_string_literal: true

require "rails_helper"

RSpec.describe ModifyExpiryDateForm, type: :model do

  subject(:form) { described_class.new(registration) }

  let(:registration) { create(:registration, :with_active_exemptions) }

  describe ".new" do
    let(:current_date) { registration.registration_exemptions.first.expires_on }

    it "populates the date fields with the current expiry date" do
      expect(form.date_year).to eq current_date.year
      expect(form.date_month).to eq current_date.month
      expect(form.date_day).to eq current_date.day
    end
  end

  describe "#submit" do
    context "when the form is not valid" do
      it "does not submit" do
        expect(form.submit(date_day: "foo", date_month: "bar", date_year: "baz")).to be(false)
      end
    end

    context "when the form is valid" do
      let(:valid_modified_date) { 1.day.from_now.to_date }

      it "submits" do
        expect(form.submit(
                 date_day: valid_modified_date.day.to_s,
                 date_month: valid_modified_date.month.to_s,
                 date_year: valid_modified_date.year.to_s
               )).to be(true)
      end

      context "with specific exemption types" do
        let(:modified_exemption) { registration.registration_exemptions.first }
        let(:original_expiry_date) { modified_exemption.expires_on }

        before do
          form.submit(
            date_day: valid_modified_date.day.to_s,
            date_month: valid_modified_date.month.to_s,
            date_year: valid_modified_date.year.to_s
          )
        end

        shared_examples "all exemptions updated" do
          it "updates the expiry date for each registration_exemption" do
            registration.registration_exemptions.each do |exemption|
              expect(exemption.expires_on).to eq(valid_modified_date)
            end
          end
        end

        shared_examples "no exemptions updated" do
          it "does not update the expiry date for any registration_exemption" do
            registration.registration_exemptions.each do |exemption|
              expect(exemption.expires_on).to eq(original_expiry_date)
            end
          end
        end

        shared_examples "only one exemption updated" do
          it "updates the expiry date for the first exemption" do
            expect(modified_exemption.expires_on).to eq valid_modified_date
          end
        end

        it "does not update the expiry date for the other exemptions" do
          registration.registration_exemptions.each do |re|
            next if re == modified_exemption

            expect(re.expires_on).to eq original_expiry_date
          end
        end

        context "with all active exemptions" do
          it_behaves_like "all exemptions updated", :active
        end

        context "with all expired exemptions" do
          before { registration.registration_exemptions.update(state: "expired") }

          it_behaves_like "all exemptions updated"
        end

        context "with all ceased exemptions" do
          before { registration.registration_exemptions.update(state: "ceased") }

          it_behaves_like "no exemptions updated"
        end

        context "with all revoked exemptions" do
          before { registration.registration_exemptions.update(state: "revoked") }

          it_behaves_like "no exemptions updated"
        end

        context "with active and ceased exemptions" do
          before { registration.registration_exemptions.first.update(state: "ceased") }

          it_behaves_like "only one exemption updated"
        end

        context "with active and revoked exemptions" do
          before { registration.registration_exemptions.first.update(state: "revoked") }

          it_behaves_like "only one exemption updated"
        end
      end
    end
  end
end
