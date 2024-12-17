# frozen_string_literal: true

module FinanceDetailsHelper
  include ActionView::Helpers::NumberHelper

  def display_pence_as_pounds_and_pence(pence:, hide_pence_if_zero: false)
    pounds = pence.to_f / 100

    if (pounds % 1).zero?
      hide_pence_if_zero ? format("%<pounds>.0f", pounds: pounds) : format("%<pounds>.2f", pounds: pounds)
    else
      format("%<pounds>.2f", pounds: pounds)
    end
  end

  def display_pence_as_pounds_sterling_and_pence(pence:, hide_pence_if_zero: false)
    pounds_and_pence = display_pence_as_pounds_and_pence(pence:, hide_pence_if_zero:)
    pence_is_zero = ((pence.to_f / 100) % 1).zero?

    number_to_currency(
      pounds_and_pence,
      unit: "£",
      precision: hide_pence_if_zero && pence_is_zero ? 0 : 2
    )
  end
end
