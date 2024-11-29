# frozen_string_literal: true

class AccountPresenter < BasePresenter
  include FinanceDetailsHelper

  def balance
    return nil unless super

    display_pence_as_pounds_sterling_and_pence(pence: super)
  end

  def successful_payments
    super.map { |payment| PaymentPresenter.new(payment) }
  end

  def refunds_and_reversals
    super.map { |payment| PaymentPresenter.new(payment) }
  end

  def sorted_orders
    super.map { |order| OrderPresenter.new(order) }
  end
end
