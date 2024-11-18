# frozen_string_literal: true

class PaymentPresenter < BasePresenter
  def initialize(payment)
    @payment = payment
    super
  end

  def payment_type
    if @payment.moto_payment
      I18n.t("shared.payment.payment_type.govpay_payment_moto")
    else
      I18n.t("shared.payment.payment_type.#{@payment.payment_type}")
    end
  end
end
