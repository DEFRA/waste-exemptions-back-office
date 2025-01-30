# frozen_string_literal: true

class AccountPresenter < BasePresenter
  include FinanceDetailsHelper

  def balance
    return nil if __getobj__.blank?

    display_pence_as_pounds_sterling_and_pence(pence: super)
  end

  def successful_payments
    return [] if __getobj__.blank?

    super.map { |payment| PaymentPresenter.new(payment) }
  end

  def refunds_and_reversals
    return [] if __getobj__.blank?

    super.map { |payment| PaymentPresenter.new(payment) }
  end

  def sorted_orders
    return [] if __getobj__.blank?

    orders.order(created_at: :desc).map { |order| OrderPresenter.new(order) }
  end

  def charge_adjustments
    return [] if __getobj__.blank?

    super.order(created_at: :desc).map { |charge_adjustment| ChargeAdjustmentPresenter.new(charge_adjustment) }
  end
end
