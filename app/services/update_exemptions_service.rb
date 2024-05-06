class UpdateExemptionsService < WasteExemptionsEngine::BaseService
  def run(params)
    ActiveRecord::Base.transaction do
      params.each do |id, exemption_data|
        exemption = WasteExemptionsEngine::Exemption.find(id)
        update_exemption(exemption, exemption_data)
      end
    end
    true
  rescue StandardError => e
    Rails.logger.error "Error updating exemptions: #{e.message}"
    false
  end

  private

  def update_exemption(exemption, exemption_data)
    exemption.update!(band_id: exemption_data['band_id'])
    update_bucket_exemptions(exemption, exemption_data['bucket_ids'])
  end

  def update_bucket_exemptions(exemption, bucket_ids)
    if bucket_ids.blank?
      exemption.bucket_exemptions.destroy_all
    else
      manage_buckets(exemption, bucket_ids.map(&:to_i))
    end
  end

  def manage_buckets(exemption, new_ids)
    current_ids = exemption.buckets.pluck(:id)
    # Destroy unneeded bucket exemptions
    exemption.bucket_exemptions.where.not(bucket_id: new_ids).destroy_all
    # Create new bucket exemptions
    (new_ids - current_ids).each do |bucket_id|
      exemption.bucket_exemptions.create!(bucket_id: bucket_id)
    end
  end
end
