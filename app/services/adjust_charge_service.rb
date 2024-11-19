class AdjustChargeService < WasteExemptionsEngine::BaseService
  def run(account:, adjustment_type:, amount:, reason:)
    @account = account
    @amount = amount
    @reason = reason
    @adjustment_type = adjustment_type

    ActiveRecord::Base.transaction do
      create_charge_adjustment
    end

    true
  rescue StandardError => e
    Airbrake.notify(e, message: "Error processing charge decrease")
    Rails.logger.error "#{e.class} error processing charge decrease"
    false
  end

  private

  attr_reader :account, :amount, :reason, :adjustment_type

  def create_charge_adjustment
    WasteExemptionsEngine::ChargeAdjustment.create!(
      account: account,
      amount: amount,
      adjustment_type: adjustment_type,
      reason: reason
    )
  end
end
