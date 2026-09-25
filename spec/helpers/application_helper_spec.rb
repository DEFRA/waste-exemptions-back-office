# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#render_markdown" do
    subject(:rendered_markdown) { helper.render_markdown(markdown) }

    let(:markdown) do
      <<~MARKDOWN
        ## Payment details

        Registration number: WEX005192
        Payment date: 22 September 2026
        Payment method: BACS
        Amount paid: £604.12

        ## Breakdown of charges

        * U1 Using waste in construction: £435.96
        * Registration charge: £58.13
        * VAT exempt: £0

        Total paid: £604.12
      MARKDOWN
    end

    it "preserves Notify line breaks and Markdown formatting" do
      expect(rendered_markdown).to include(
        "<h2>Payment details</h2>",
        "Registration number: WEX005192<br>\nPayment date: 22 September 2026<br>",
        "<h2>Breakdown of charges</h2>",
        "<li>U1 Using waste in construction: £435.96</li>",
        "<p>Total paid: £604.12</p>"
      )
    end
  end
end
