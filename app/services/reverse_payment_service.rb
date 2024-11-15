# frozen_string_literal: true

class ReversePaymentService < WasteExemptionsEngine::BaseService
  def run(comments:, payment:, user:)
    @payment = payment
    @comments = comments
    @user = user

    reversal = build_reversal

    ActiveRecord::Base.transaction do
      reversal.save!
      payment.update!(
        reversal_id: reversal.id,
        reversed_by: user.email,
        reversed_at: Time.current
      )

      account = payment.account
      account.save!
    end

    true
  rescue StandardError => e
    Rails.logger.error "#{e.class} error processing reversal for payment #{payment.id}"
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
      comments: comments
    )
  end
end
