# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "matching and non matching registrations" do
  it "returns a matching registration" do
    expect(scope).to include(matching_registration)
  end

  it "does not return others" do
    expect(scope).not_to include(non_matching_registration)
  end
end

RSpec.shared_examples "searching phone number attribute" do |phone_type|
  let(:normal_number) { "01234567890" }
  let(:number_with_spaces) { "012 3456 7890" }
  let(:number_with_dashes) { "012-3456-7890" }
  let(:number_starting_with_44) { "+441234567890" }
  let(:interntational_number) { "+78121234567" }

  before do
    non_matching_registration.update_attribute(:applicant_phone, "0121117890")
    non_matching_registration.update_attribute(:contact_phone, "0121117890")
  end

  context "when the number in the database has not got any spaces or dashes and doesn't start in +44" do
    before do
      matching_registration.update_attribute(phone_type, normal_number)
    end

    context "and the search term has not got any spaces or dashes and doesn't start in +44" do
      let(:term) { normal_number.to_s }
      it_behaves_like "matching and non matching registrations"
    end

    context "but the search term has spaces" do
      let(:term) { number_with_spaces.to_s }
      it_behaves_like "matching and non matching registrations"
    end

    context "but the search term has dashes" do
      let(:term) { number_with_dashes.to_s }
      it_behaves_like "matching and non matching registrations"
    end

    context "but the search term starts with +44" do
      let(:term) { number_starting_with_44.to_s }
      it_behaves_like "matching and non matching registrations"
    end
  end

  context "when the number in the search term has got any spaces or dashes and doesn't start in +44" do
    let(:term) { normal_number.to_s }
    context "and the database has not got any spaces or dashes and doesn't start in +44" do
      before do
        matching_registration.update_attribute(phone_type, normal_number)
      end
      it_behaves_like "matching and non matching registrations"
    end

    context "but the database has spaces" do
      before do
        matching_registration.update_attribute(phone_type, number_with_spaces)
      end
      it_behaves_like "matching and non matching registrations"
    end

    context "but the database has dashes" do
      before do
        matching_registration.update_attribute(phone_type, number_with_dashes)
      end
      it_behaves_like "matching and non matching registrations"
    end

    context "but the database starts with +44" do
      before do
        matching_registration.update_attribute(phone_type, number_starting_with_44)
      end
      it_behaves_like "matching and non matching registrations"
    end
  end

  context "when the search term is an international number" do
    context "it only produces exact matches" do
      let(:term) { interntational_number.to_s }

      before do
        matching_registration.update_attribute(phone_type, interntational_number)
      end

      it_behaves_like "matching and non matching registrations"
    end
  end
end
