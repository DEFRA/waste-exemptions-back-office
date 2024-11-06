# frozen_string_literal: true

class RecordRefundService < WasteExemptionsEngine::BaseService
  def run(reason:, payment:, amount_in_pounds:)
    @amount = amount_in_pounds * 100
    @payment = payment
    @reason = reason

    refund = build_refund(@amount)
    refund.save!

    account = payment.account
    account.update_balance!
    account.save!

    true
  rescue StandardError => e
    Rails.logger.error "#{e.class} error processing refund for payment #{payment.id}"
    Airbrake.notify(e, message: "Error processing refund for payment ", payment_id: payment.id)
    false
  end

  private

  attr_reader :payment, :reason

  def build_refund(amount)
    WasteExemptionsEngine::Payment.new(
      payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND,
      payment_amount: -amount,
      payment_status: WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS,
      account_id: payment.account_id,
      payment_uuid: SecureRandom.uuid,
      reason: reason
    )
  end
end
