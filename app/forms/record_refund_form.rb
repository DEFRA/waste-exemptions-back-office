  class RecordRefundForm
    include ActiveModel::Model

    attr_accessor :reason, :payment_id, :amount

    validates :reason, presence: true
    validates :payment_id, presence: true
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validate :amount_within_limits

    def initialize(attributes = {})
      super
    end

    def submit(params, record_refund_service: RecordRefundService)
      self.amount = params[:amount]
      self.reason = params[:reason]
      self.payment_id = params[:payment_id]

      payment = WasteExemptionsEngine::Payment.find_by(id: payment_id) if payment_id.present?
      @max_amount = payment&.payment_amount.to_f / 100 if payment
      return false unless valid?

      Rails.logger.info "running RecordRefundService with arguments: #{reason}, #{payment}, #{amount.to_f}"
      record_refund_service.run(reason: reason,
                              payment: payment,
                              amount_in_pounds: amount.to_f)
    end

    private

    attr_reader :payment, :max_amount

    def amount_within_limits
      return if amount.blank? || !amount.to_f.positive?

      if amount.to_f > max_amount
        errors.add(:amount, "must not exceed maximum refund amount of £#{max_amount}")
      end

      account = payment&.account
      if account && (amount.to_f * 100) > account.balance
        errors.add(:amount, "must not exceed available account balance of £#{account.balance / 100}")
      end
    end
  end
