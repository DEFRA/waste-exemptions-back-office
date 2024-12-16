# frozen_string_literal: true

class AdjustmentTypeForm
  include ActiveModel::Model

  TYPES = %w[increase decrease].freeze

  attr_accessor :adjustment_type

  validates :adjustment_type, presence: true, inclusion: { in: TYPES }

  def submit(params)
    self.adjustment_type = params[:adjustment_type]
    valid?
  end
end
