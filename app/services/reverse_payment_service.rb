# frozen_string_literal: true

class ReversePaymentService < WasteExemptionsEngine::BaseService
  def run(comments:, payment:, user:)
    @payment = payment
    @comments = comments
    @user = user

    reversal = build_reversal
    reversal.save!

    true
  rescue StandardError => e
    Rails.logger.error "#{e.class}:#{e.message} error processing reversal for payment #{payment.id}"
    Airbrake.notify(e, message: "Error processing reversal for payment ", payment_id: payment.id)
    false
  end

  private

  attr_reader :payment, :comments, :user

  def build_reversal
    WasteExemptionsEngine::Payment.new(
      payment_type: WasteExemptionsEngine::Payment::PAYMENT_TYPE_REVERSAL,
      payment_amount: -payment.payment_amount,
      payment_status: WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS,
      account_id: payment.account_id,
      reference: "#{payment.reference}/REVERSAL",
      payment_uuid: SecureRandom.uuid,
      comments: comments,
      associated_payment: payment,
      created_by: user.email
    )
  end
end
