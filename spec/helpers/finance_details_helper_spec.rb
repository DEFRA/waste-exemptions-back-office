# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinanceDetailsHelper do

  describe "display_pence_as_pounds_and_pence" do
    subject(:formatted_amount) { helper.display_pence_as_pounds_and_pence(pence, hide_pence_if_zero) }

    context "when the value is a whole number of pounds" do
      let(:pence) { 12_300 }

      context "when hide_pence_if_zero is false" do
        let(:hide_pence_if_zero) { false }

        it { expect(formatted_amount).to eq "123.00" }
      end

      context "when hide_pence_if_zero is true" do
        let(:hide_pence_if_zero) { true }

        it { expect(formatted_amount).to eq "123" }
      end
    end

    context "when the value is a fractional number of pounds" do
      let(:pence) { 12_305 }

      context "when hide_pence_if_zero is false" do
        let(:hide_pence_if_zero) { false }

        it { expect(formatted_amount).to eq "123.05" }
      end

      context "when hide_pence_if_zero is true" do
        let(:hide_pence_if_zero) { true }

        it { expect(formatted_amount).to eq "123.05" }
      end
    end
  end

  describe "display_pence_as_pounds_and_pence_with_symbol" do
    subject(:formatted_amount) { helper.display_pence_as_pounds_sterling_and_pence(pence, hide_pence_if_zero) }

    context "when the value is a whole number of pounds" do
      let(:pence) { 12_300 }

      context "when hide_pence_if_zero is false" do
        let(:hide_pence_if_zero) { false }

        it { expect(formatted_amount).to eq "£123.00" }
      end

      context "when hide_pence_if_zero is true" do
        let(:hide_pence_if_zero) { true }

        it { expect(formatted_amount).to eq "£123" }
      end
    end

    context "when the value is a fractional number of pounds" do
      let(:pence) { 12_305 }

      context "when hide_pence_if_zero is false" do
        let(:hide_pence_if_zero) { false }

        it { expect(formatted_amount).to eq "£123.05" }
      end

      context "when hide_pence_if_zero is true" do
        let(:hide_pence_if_zero) { true }

        it { expect(formatted_amount).to eq "£123.05" }
      end
    end
  end
end
