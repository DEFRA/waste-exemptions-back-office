# frozen_string_literal: true

class RecordReversalForm
  include ActiveModel::Model

  attr_accessor :comments, :payment_id

  validates :payment_id, presence: true
  validate :reason_present_in_comments

  def submit(params)
    self.comments = params[:comments]
    self.payment_id = params[:payment_id]

    return false unless valid?

    payment = WasteExemptionsEngine::Payment.find_by(id: payment_id)

    Rails.logger.info "running ReversePaymentService with arguments: #{comments}, #{payment}"

    ReversePaymentService.new.run(
      comments: comments,
      payment: payment
    )
  end

  private

  def reason_present_in_comments
    return if comments.present?

    errors.add(:comments, I18n.t(".record_refunds.form.errors.reason_missing"))
  end
end
