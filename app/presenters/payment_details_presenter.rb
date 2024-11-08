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
    @orders ||= account&.orders&.sort_by(&:created_at)&.reverse || []
  end

  def payments
    @payments ||= account
                  &.payments
                  &.where&.not(payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND)
  end

  def refunds
    @refunds ||= account
                 &.payments
                 &.where(payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND)
  end

  def balance
    return nil unless registration.account&.balance

    display_pence_as_pounds_and_cents(registration.account.balance)
  end

  def format_date(datetime)
    datetime&.strftime("%Y-%m-%d")
  end

  def order_exemption_codes(order)
    order.exemptions.map(&:code).sort.join(",")
  end
end
