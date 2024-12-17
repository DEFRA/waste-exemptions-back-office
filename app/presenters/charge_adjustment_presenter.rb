# frozen_string_literal: true

class ChargeAdjustmentPresenter < BasePresenter
  include FinanceDetailsHelper

  def amount
    display_pence_as_pounds_sterling_and_pence(pence: super)
  end

  def created_at
    format_date(super)
  end

  def adjustment_type
    I18n.t("shared.charge_adjustments.adjustment_type.#{super}")
  end
end
