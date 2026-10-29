# frozen_string_literal: true

class RestoreExemptionsForm
  include ActiveModel::Model

  attr_accessor :message

  def submit(params, restoration_service)
    self.message = params[:message]&.strip
    restoration_service.restore!(message) if valid?
    valid?
  end

  validates :message, restoration_message: true
end
