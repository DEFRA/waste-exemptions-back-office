# frozen_string_literal: true

class RecordRefundService < WasteExemptionsEngine::BaseService
  def run(comments:, payment:, amount_in_pence:)
    @payment = payment
    @comments = comments
    @amount = amount_in_pence

    refund = build_refund
    refund.save!

    true
  rescue StandardError => e
    Rails.logger.error "#{e.class} error processing refund for payment #{payment&.id}"
    Airbrake.notify(e, message: "Error processing refund for payment ", payment_id: payment&.id)
    false
  end

  private

  attr_reader :payment, :comments, :amount

  def build_refund
    WasteExemptionsEngine::Payment.new(
      payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND,
      payment_amount: -amount,
      payment_status: WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS,
      account_id: payment.account_id,
      reference: "#{payment.reference}/REFUND",
      payment_uuid: SecureRandom.uuid,
      comments: comments,
      associated_payment_id: payment.id
    )
  end
end
