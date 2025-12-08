# frozen_string_literal: true

class DeregistrationService

  attr_reader :current_user, :resource

  def initialize(current_user, resource)
    @current_user = current_user
    @resource = resource
  end

  def deregister!(state_transition, deregistration_message)
    return unless current_user.can?(:deregister, resource)

    if resource.is_a?(WasteExemptionsEngine::Registration) || resource.is_a?(WasteExemptionsEngine::Address)
      resource.registration_exemptions.each do |re|
        DeregistrationService.new(current_user, re).deregister!(state_transition, deregistration_message)
      end
    else
      # Assign current_user's email address as version author
      PaperTrail.request(whodunnit: current_user.email) do
        # Apply the new state via the AASM helper method.
        resource.public_send("#{state_transition}!")
        resource.update(deregistration_message: deregistration_message, deregistered_by: current_user.email)
      end
    end
  end
end
