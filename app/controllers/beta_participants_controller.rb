# frozen_string_literal: true

class BetaParticipantsController < ApplicationController
  def index
    @participants = WasteExemptionsEngine::BetaParticipant.order(invited_at: :desc)
  end
end
