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
        # Set the reason first so it lands in the version the transition writes.
        resource.reason_for_change = restoration_message
        resource.restore!
      end
    end
  end
end
