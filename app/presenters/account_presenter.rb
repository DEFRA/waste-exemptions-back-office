# frozen_string_literal: true

class AccountPresenter < BasePresenter
  include FinanceDetailsHelper

  def balance
    return nil unless super

    display_pence_as_pounds_sterling_and_pence(pence: super)
  end

  def successful_payments
    payments.successful_payments.map {|payment| PaymentPresenter.new(payment) }
  end

  def refunds_and_reversals
    payments.refunds_and_reversals.map {|payment| PaymentPresenter.new(payment) }
  end

  def orders
    super.recent_first.map {|order| OrderPresenter.new(order) }
  end
end
