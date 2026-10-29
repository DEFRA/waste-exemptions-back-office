# frozen_string_literal: true

class RestorationService

  attr_reader :current_user, :resource

  def initialize(current_user, resource)
    @current_user = current_user
    @resource = resource
  end

  def restore!(restoration_message)
    return unless current_user.can?(:restore, resource)

    if resource.is_a?(WasteExemptionsEngine::Registration)
      resource.registration_exemptions.each do |re|
        RestorationService.new(current_user, re).restore!(restoration_message)
      end
    else
      # Assign current_user's email address as version author
      PaperTrail.request(whodunnit: current_user.email) do
        # Apply the new state via the AASM helper method.
        resource.restore!
        resource.update(reason_for_change: restoration_message)
      end
    end
  end
end
