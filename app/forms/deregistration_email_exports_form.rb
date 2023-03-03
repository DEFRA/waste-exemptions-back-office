# frozen_string_literal: true

class DeregistrationEmailExportsForm
  include ActiveModel::Model

  validates :batch_size, presence: true

  def submit(params)
    Reports::DeregistrationEmailBatchExportService.run(
      batch_size: params[:batch_size].to_i
    )
  end

  def batch_size
    Rails.configuration.registration_email_batch_size
  end
end
