# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe BaseRegistrationRowPresenter do
      let(:site_address) { create(:address, :site_address, premises: "Bar 123", area: "Wessex") }
      let(:registration) { create(:registration, addresses: [site_address]) }
      let(:presenter) { described_class.new(registration: registration) }

      before do
        registration.reference = "REG123"
      end

      describe "#registration_no" do
        it "returns the registration reference" do
          expect(presenter.registration_no).to eq("REG123")
        end
      end

      describe "#date" do
        it "returns the formatted submitted_at date" do
          formatted_date = registration.submitted_at.to_fs(:day_month_year_slashes)
          expect(presenter.date).to eq(formatted_date)
        end
      end

      describe "#charge_type" do
        it "returns nil" do
          expect(presenter.charge_type).to be_nil
        end
      end

      describe "#charge_amount" do
        it "returns nil" do
          expect(presenter.charge_amount).to be_nil
        end
      end

      describe "#charge_band" do
        it "returns nil" do
          expect(presenter.charge_band).to be_nil
        end
      end

      describe "#exemption" do
        it "returns nil" do
          expect(presenter.exemption).to be_nil
        end
      end

      describe "#payment_type" do
        it "returns nil" do
          expect(presenter.payment_type).to be_nil
        end
      end

      describe "#refund_type" do
        it "returns nil" do
          expect(presenter.refund_type).to be_nil
        end
      end

      describe "#reference" do
        it "returns nil" do
          expect(presenter.reference).to be_nil
        end
      end

      describe "#comments" do
        it "returns nil" do
          expect(presenter.comments).to be_nil
        end
      end

      describe "#payment_amount" do
        it "returns nil" do
          expect(presenter.payment_amount).to be_nil
        end
      end

      describe "#on_a_farm" do
        it "returns nil" do
          expect(presenter.on_a_farm).to be_present
        end
      end

      describe "#is_a_farmer" do
        it "returns nil" do
          expect(presenter.is_a_farmer).to be_present
        end
      end

      describe "#ea_admin_area" do
        it "returns nil" do
          expect(presenter.ea_admin_area).to be_present
        end
      end

      describe "#balance" do
        it "returns nil" do
          expect(presenter.balance).to be_nil
        end
      end

      describe "multisite-specific behavior" do
        let(:site_address_with_suffix) do
          create(:address, :site_address, site_suffix: "00001", area: "Yorkshire")
        end
        let(:multisite_presenter) do
          described_class.new(registration: registration, site_address: site_address_with_suffix)
        end

        describe "#registration_no" do
          it "includes site suffix when site_address has one" do
            expect(multisite_presenter.registration_no).to eq("REG123/00001")
          end

          it "returns just reference when site_address has no suffix" do
            expect(presenter.registration_no).to eq("REG123")
          end
        end

        describe "#multisite" do
          it "returns TRUE for multisite registrations" do
            allow(registration).to receive(:multisite?).and_return(true)
            expect(presenter.multisite).to eq("TRUE")
          end

          it "returns FALSE for non-multisite registrations" do
            allow(registration).to receive(:multisite?).and_return(false)
            expect(presenter.multisite).to eq("FALSE")
          end
        end

        describe "#site" do
          it "returns site_suffix when present" do
            expect(multisite_presenter.site).to eq("00001")
          end

          it "returns nil when site_address has no suffix" do
            expect(presenter.site).to be_nil
          end
        end

        describe "#ea_admin_area" do
          it "returns area from site_address when provided" do
            expect(multisite_presenter.ea_admin_area).to eq("Yorkshire")
          end

          it "falls back to registration site_address area" do
            expect(presenter.ea_admin_area).to eq("Wessex")
          end
        end

        describe "#status" do
          it "returns site_status when site_address is provided" do
            allow(site_address_with_suffix).to receive(:site_status).and_return("active")
            expect(multisite_presenter.status).to eq("active")
          end

          it "returns registration state when no site_address provided" do
            allow(registration).to receive(:state).and_return("pending")
            expect(presenter.status).to eq("pending")
          end
        end
      end
    end
  end
end
