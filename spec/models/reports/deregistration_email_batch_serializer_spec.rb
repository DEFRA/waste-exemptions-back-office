# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::DeregistrationEmailBatchSerializer do
  subject(:csv) do
    CSV.parse(
      described_class.new(batch_size: test_batch_size).to_csv
    )
  end

  let(:test_batch_size) { 1 }

  describe "#to_csv" do
    context "with one registration" do
      let(:registration) do
        create(:registration, :eligible_for_deregistration,
               contact_email: "foo@bar.com", applicant_email: "foo@bar.com")
      end

      before { registration }

      it "includes the correct number of registrations in the CSV" do
        expect(csv.length).to eq(test_batch_size + 1)
      end

      it "includes the correct header" do
        expect(csv.first.map(&:to_sym)).to eq([:email, *described_class::ATTRIBUTES])
      end

      it "includes the correct fields" do
        expected = [
          "foo@bar.com",
          "#{registration.contact_first_name} #{registration.contact_last_name}",
          "ST 58337 72855",
          registration.reference,
          "http://localhost:3000/renew/#{registration.renew_token}",
          registration.exemptions.map do |ex|
            "#{ex.code} #{ex.summary}"
          end.to_s
        ]

        expect(csv.second).to eq(expected)
      end
    end

    context "with differing contact and applicant emails" do
      let(:registration) do
        create(:registration, :eligible_for_deregistration,
               contact_email: "foo@bar.com", applicant_email: "foo@baz.com")
      end

      before { registration }

      it "includes the correct number of registrations in the CSV" do
        expect(csv.length).to eq((test_batch_size * 2) + 1)
      end

      it "includes separate rows for applicant and contact emails" do
        expect(csv[1][0]).to eq(registration.contact_email)
        expect(csv[2][0]).to eq(registration.applicant_email)
      end
    end

    context "with valid registrations" do
      let(:registrations) do
        create_list(:registration, 3, :eligible_for_deregistration,
                    contact_email: "foo@bar.com", applicant_email: "foo@bar.com")
      end

      let(:test_batch_size) { 2 }

      before { registrations }

      it "includes the correct number of registrations in the CSV" do
        expect(csv.length).to eq(test_batch_size + 1)
      end

      it "drops the created temporary table" do
        csv

        res = ActiveRecord::Base.connection.execute <<-SQL.squish
          SELECT exists (
            SELECT FROM information_schema.tables
            WHERE table_name = '#{described_class::TEMP_TABLE_NAME}');
        SQL

        expect(res.first.fetch("exists")).to be(false)
      end
    end

    context "with a batch size larger than the number of registrations" do
      let(:registrations_count) { 3 }

      let(:registrations) do
        create_list(:registration, registrations_count, :eligible_for_deregistration,
                    contact_email: "foo@bar.com", applicant_email: "foo@bar.com")
      end

      let(:test_batch_size) { registrations.size * 2 }

      before { registrations }

      it "includes the correct number of registrations in the CSV" do
        expect(csv.length).to eq(registrations_count + 1)
      end
    end

    context "when the de-registration email has already been sent" do
      let(:registration) do
        create(:registration, :eligible_for_deregistration, deregistration_email_sent_at: Time.zone.now)
      end

      before { registration }

      it "does not include any registrations" do
        expect(csv.length).to eq(1) # header only
      end
    end

    context "when the registration has been submitted too recently" do
      let(:registration) do
        create(:registration, :eligible_for_deregistration, submitted_at: 1.day.ago)
      end

      before { registration }

      it "does not include any registrations" do
        expect(csv.length).to eq(1) # header only
      end
    end

    context "when all exemptions are within the renewal window" do
      let(:registration) do
        create(
          :registration,
          :eligible_for_deregistration,
          registration_exemptions: build_list(:registration_exemption, 1, expires_on: Date.yesterday)
        )
      end

      before { registration }

      it "does not include any registrations" do
        expect(csv.length).to eq(1) # header only
      end
    end
  end
end
