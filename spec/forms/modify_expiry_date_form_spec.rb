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

      it "updates the registration date for each registration_exemption" do
        form.submit(
          date_day: valid_modified_date.day.to_s,
          date_month: valid_modified_date.month.to_s,
          date_year: valid_modified_date.year.to_s
        )

        registration.registration_exemptions.each do |exemption|
          expect(exemption.expires_on).to eq(valid_modified_date)
        end
      end
    end
  end
end
