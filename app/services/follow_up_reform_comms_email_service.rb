# frozen_string_literal: true

# Sends the reform comms email again to a contact whose earlier one was not delivered, under its
# own label so the follow-up can be told apart from the original.
class FollowUpReformCommsEmailService < ReformCommsEmailService
  TEMPLATE_ID = OctoberReformCommsEmailService::TEMPLATE_ID
  TEMPLATE_LABEL = "Reform comms follow-up email - November 2026"
end
