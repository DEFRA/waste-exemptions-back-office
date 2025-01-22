# frozen_string_literal: true

def seed_beta_participants
  seeds = JSON.parse(Rails.root.join("db/seeds/beta_participants.json").read)

  beta_participants = seeds["beta_participants"]
  beta_participants.each do |beta_participant|
    participant = WasteExemptionsEngine::BetaParticipant.find_or_initialize_by(email: beta_participant["email"])
    participant.reg_number = beta_participant["reg_number"]
    participant.token = beta_participant["token"] if beta_participant["token"].present?
    participant.save! if participant.changed?
  end
end

seed_beta_participants if !Rails.env.production? || ENV["ALLOW_SEED"]
