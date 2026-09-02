# frozen_string_literal: true

class RegistrationNonPaymentPresenter < BasePresenter
  include FinanceDetailsHelper

  def amount_owed
    display_pence_as_pounds_sterling_and_pence(pence: super, hide_pence_if_zero: true)
  end

  def amount_owed_in_pounds
    display_pence_as_pounds_and_pence(pence: model.amount_owed)
  end

  def days_since_registration
    return nil if submitted_at.blank?

    (Date.current - submitted_at).to_i
  end
end
