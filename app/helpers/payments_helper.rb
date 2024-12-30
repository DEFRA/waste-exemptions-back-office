# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable
module PaymentsHelper
  LOCALE = "payments.helper"

  def preselect_missing_card_payment_radio_button?
    # return true if @filter.blank?

    payment_type == :missing_card_payment
  end

  def preselect_bank_transfer_radio_button?
    payment_type == :bank_transfer
  end

  def preselect_other_payment_radio_button?
    payment_type == :other_payment
  end

  def payment_type
    return if params&.dig(:add_payment_form, :payment_type).blank?

    @payment_type = params[:add_payment_form][:payment_type].to_sym
  end
end
# rubocop:enable Rails/HelperInstanceVariable
