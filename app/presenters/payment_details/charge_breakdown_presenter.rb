# frozen_string_literal: true

module PaymentDetails
  class ChargeBreakdownPresenter
    class Row
      attr_reader :label, :amount_pence

      def initialize(label:, amount_pence:, top_padded: false, total: false)
        @label = label
        @amount_pence = amount_pence
        @top_padded = top_padded
        @total = total
      end

      def breakdown_cell_classes
        return "charge-breakdown__breakdown-cell govuk-table__cell govuk-!-padding-top-0" if @total
        return "charge-breakdown__breakdown-cell govuk-!-padding-top-2" if @top_padded

        "charge-breakdown__breakdown-cell"
      end

      def amount_cell_classes
        return "govuk-table__cell govuk-!-text-align-right govuk-!-padding-top-0" if @total
        return "govuk-!-text-align-right govuk-!-padding-top-2 vertical-align-top" if @top_padded

        "govuk-!-text-align-right vertical-align-top"
      end
    end

    def initialize(order:, is_multisite: false)
      @order = order.is_a?(OrderPresenter) ? order : OrderPresenter.new(order)
      @is_multisite = is_multisite
    end

    def date
      @order.created_at
    end

    def rowspan
      rows.length
    end

    def rows
      @rows ||= row_definitions.each_with_index.map do |definition, index|
        Row.new(**definition, top_padded: index.zero?)
      end
    end

    private

    def row_definitions
      [
        optional_row(
          label: exemption_label(@order.chargeable_exemption_codes_excluding_bucket),
          amount_pence: @order.charge_detail&.total_compliance_charge_amount_excluding_bucket
        ),
        optional_row(
          label: exemption_label(@order.no_charge_exemption_codes_excluding_bucket),
          amount_pence: 0
        ),
        bucket_row,
        row(
          label: I18n.t("payment_details.charge_breakdown.details_section.charges.registration_charge_label"),
          amount_pence: @order.charge_detail&.registration_charge_amount
        ),
        row(
          label: I18n.t("payment_details.charge_breakdown.details_section.charges.total_charge_label"),
          amount_pence: @order.charge_detail&.total_charge_amount,
          total: true
        )
      ].compact
    end

    def bucket_row
      return if @order.bucket_exemption_codes.blank?

      row(
        label: exemption_label("#{bucket_label} #{@order.bucket_exemption_codes}"),
        amount_pence: @order.charge_detail&.bucket_charge_amount
      )
    end

    def optional_row(label:, amount_pence:)
      return if label.blank?

      row(label:, amount_pence:)
    end

    def row(label:, amount_pence:, total: false)
      { label:, amount_pence:, total: }
    end

    def exemption_label(label)
      return if label.blank?

      return label unless @is_multisite

      "#{label} x [#{@order.site_count}]"
    end

    def bucket_label
      I18n.t(
        "payment_details.charge_breakdown.details_section.charges.bucket_exemptions_label.#{@order.bucket.bucket_type}"
      )
    end
  end
end
