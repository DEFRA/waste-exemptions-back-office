class ChargeAdjustmentForm
  include ActiveModel::Model

  TYPES = %w[increase decrease].freeze

  attr_accessor :adjustment_type, :amount, :reason, :account

  validates :adjustment_type, presence: true, inclusion: { in: TYPES }
  validates :amount,
    "defra_ruby/validators/price": true,
    presence: true, numericality: { greater_than: 0 }
  validates :reason, presence: true

  def submit(params)
    self.adjustment_type = params[:adjustment_type]
    self.amount = params[:amount]
    self.reason = params[:reason]

    return false unless valid?

    AdjustChargeService.run(
      adjustment_type: adjustment_type,
      amount: amount.to_f * 100,
      reason: reason,
      account: account
    )
  end
end
