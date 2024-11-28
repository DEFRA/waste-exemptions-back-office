#frozen_string_literal: true

class PaymentPresenter < BasePresenter
  include FinanceDetailsHelper

  def payment_type
    if moto_payment
      I18n.t("shared.payment.payment_type.govpay_payment_moto")
    else
      I18n.t("shared.payment.payment_type.#{super}")
    end
  end

  def payment_amount
    display_pence_as_pounds_sterling_and_pence(pence: super)
  end
end
