# frozen_string_literal: true

# Scope of active registrations which still owe money, used by the registration
# non-payments page and its CSV export.
class RegistrationNonPaymentsService < WasteExemptionsEngine::BaseService
  MINIMUM_AMOUNT_OWED_IN_PENCE = 500

  def run
    WasteExemptionsEngine::Registration
      .from("(#{registrations_with_amount_owed.to_sql}) AS registrations")
      .where(amount_owed: MINIMUM_AMOUNT_OWED_IN_PENCE..)
      .order(submitted_at: :asc)
  end

  private

  def registrations_with_amount_owed
    WasteExemptionsEngine::Registration
      .select("registrations.*", "#{total_due} - #{total_paid} AS amount_owed")
      .joins(:account)
      .where(id: WasteExemptionsEngine::RegistrationExemption.active.select(:registration_id))
  end

  def total_due
    "#{orders_total} + #{charge_adjustments_total}"
  end

  def orders_total
    <<~SQL.squish
      COALESCE((
        SELECT SUM(charge_details.total_charge_amount)
        FROM orders
        INNER JOIN charge_details ON charge_details.order_id = orders.id
        WHERE orders.order_owner_type = '#{WasteExemptionsEngine::Account.polymorphic_name}'
        AND orders.order_owner_id = accounts.id
      ), 0)
    SQL
  end

  def charge_adjustments_total
    <<~SQL.squish
      COALESCE((
        SELECT SUM(CASE WHEN charge_adjustments.adjustment_type = 'increase'
                        THEN charge_adjustments.amount
                        ELSE -charge_adjustments.amount END)
        FROM charge_adjustments
        WHERE charge_adjustments.account_id = accounts.id
      ), 0)
    SQL
  end

  def total_paid
    <<~SQL.squish
      COALESCE((
        SELECT SUM(payments.payment_amount)
        FROM payments
        WHERE payments.account_id = accounts.id
        AND payments.payment_status = '#{WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS}'
      ), 0)
    SQL
  end
end
