# frozen_string_literal: true

class BetaParticipantsController < ApplicationController
  def index
    @participants = WasteExemptionsEngine::BetaParticipant.all.order(created_at: :desc)
  end

  def new
    @participant = WasteExemptionsEngine::BetaParticipant.new
  end

  def create
    @participant = WasteExemptionsEngine::BetaParticipant.new(participant_params)

    if @participant.save
      redirect_to beta_participants_url
    else
      render :new
    end
  end

  private

  def participant_params
    params.require(:beta_participant).permit(:reg_number, :email)
  end
end
