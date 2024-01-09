# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard" do
  let(:user) { create(:user, :system) }

  before do
    login_as user

    visit "/"
  end

  it "shows logged in user details on the dashboard" do
    expect(page).to have_text("Signed in as")
    expect(page).to have_text(user.email)
  end

  describe "Search", :js do
    let(:registration) { create(:registration) }

    context "when search terms contain invalid characters" do
      before do
        registration.update(reference: "WEX000001")
      end

      it "strips tab character within the search terms and returns search results" do
        reference_with_tabs = "WEX00	0001"

        expect(page).to have_field("term")
        fill_in "term", with: reference_with_tabs
        expect(page).to have_button("Search")
        click_on "Search"

        expect(page).to have_text("Reference number")
        expect(page).to have_text("WEX000001")
      end

      it "strips ampersant character within the search terms and returns search results" do
        reference_with_tabs = "WEX&000001"

        expect(page).to have_field("term")
        fill_in "term", with: reference_with_tabs
        expect(page).to have_button("Search")
        click_on "Search"

        expect(page).to have_text("Reference number")
        expect(page).to have_text("WEX000001")
      end

      it "strips double quote character within the search terms and returns search results" do
        reference_with_tabs = "WEX\"000001"

        expect(page).to have_field("term")
        fill_in "term", with: reference_with_tabs
        expect(page).to have_button("Search")
        click_on "Search"

        expect(page).to have_text("Reference number")
        expect(page).to have_text("WEX000001")
      end

      it "strips single quote character within the search terms and returns search results" do
        reference_with_tabs = "WEX'000001"

        expect(page).to have_field("term")
        fill_in "term", with: reference_with_tabs
        expect(page).to have_button("Search")
        click_on "Search"

        expect(page).to have_text("Reference number")
        expect(page).to have_text("WEX000001")
      end

      it "strips less-than character within the search terms and returns search results" do
        reference_with_tabs = "WEX<000001"

        expect(page).to have_field("term")
        fill_in "term", with: reference_with_tabs
        expect(page).to have_button("Search")
        click_on "Search"

        expect(page).to have_text("Reference number")
        expect(page).to have_text("WEX000001")
      end

      it "strips greater-than character within the search terms and returns search results" do
        reference_with_tabs = "WEX>000001"

        expect(page).to have_field("term")
        fill_in "term", with: reference_with_tabs
        expect(page).to have_button("Search")
        click_on "Search"

        expect(page).to have_text("Reference number")
        expect(page).to have_text("WEX000001")
      end

      it "strips forward slash character within the search terms and returns search results" do
        reference_with_tabs = "WEX/000001"

        expect(page).to have_field("term")
        fill_in "term", with: reference_with_tabs
        expect(page).to have_button("Search")
        click_on "Search"

        expect(page).to have_text("Reference number")
        expect(page).to have_text("WEX000001")
      end
    end
  end
end
