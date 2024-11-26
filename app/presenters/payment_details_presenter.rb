# frozen_string_literal: true

class PaymentDetailsPresenter
  include ActionView::Helpers::NumberHelper
  include FinanceDetailsHelper

  attr_reader :registration

  delegate :account, to: :registration

  def initialize(registration)
    @registration = registration
  end

  def orders
    @orders ||= account.orders.sort_by(&:created_at).reverse
  end

  def payments
    @payments ||= account
                  .payments
                  .success
                  .excluding_refunds_and_reversals
                  .order(date_time: :desc)
  end

  def refunds_and_reversals
    @refunds_and_reversals ||= account
                               .payments
                               .success
                               .refunds_and_reversals
                               .order(date_time: :desc)
  end

  def balance
    return nil unless registration.account.balance

    display_pence_as_pounds_sterling_and_pence(pence: registration.account.balance)
  end

  def can_display_refund_link?
    registration
      .account
      .overpaid?
  end

  def can_display_reversal_link?
    registration
      .account
      .payments
      .refundable.any?
  end

  def format_date(datetime)
    datetime.to_date.to_fs(:day_month_year_slashes)
  end

  def order_exemption_codes(order)
    order.exemptions.map(&:code).sort.join(",")
  end

  def payment_type(payment)
    if payment.moto_payment
      I18n.t("shared.payment.payment_type.govpay_payment_moto")
    else
      I18n.t("shared.payment.payment_type.#{payment.payment_type}")
    end
  end
end
