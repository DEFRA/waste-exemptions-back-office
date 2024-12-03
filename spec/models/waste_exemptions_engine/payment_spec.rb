# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Payment do
  let(:account) { create(:account, registration: create(:registration)) }
  describe "#successful_payments" do
    let(:successful_payments_scope) { instance_double(ActiveRecord::Relation) }

    it "calls successful_payments on the payments association" do
      allow(account.payments).to receive(:successful_payments).and_return(successful_payments_scope)
      account.successful_payments

      expect(account.payments).to have_received(:successful_payments)
    end

    it "returns the successful_payments scope" do
      allow(account.payments).to receive(:successful_payments).and_return(successful_payments_scope)

      expect(account.successful_payments).to eq(successful_payments_scope)
    end
  end

  describe "#refunds_and_reversals" do
    let(:refunds_scope) { instance_double(ActiveRecord::Relation) }

    it "calls refunds_and_reversals on the payments association" do
      allow(account.payments).to receive(:refunds_and_reversals).and_return(refunds_scope)
      account.refunds_and_reversals

      expect(account.payments).to have_received(:refunds_and_reversals)
    end

    it "returns the refunds_and_reversals scope" do
      allow(account.payments).to receive(:refunds_and_reversals).and_return(refunds_scope)

      expect(account.refunds_and_reversals).to eq(refunds_scope)
    end
  end
end
