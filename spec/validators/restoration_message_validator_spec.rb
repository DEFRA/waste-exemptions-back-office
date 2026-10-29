# frozen_string_literal: true

require "rails_helper"

module Test
  RestorationMessageValidatable = Struct.new(:message) do
    include ActiveModel::Validations

    validates :message, restoration_message: true
  end
end

module WasteExemptionsEngine
  RSpec.describe RestorationMessageValidator, type: :model do
    # The max message length is 500.
    it_behaves_like "a validator", Test::RestorationMessageValidatable, :message, "Deregistered in error."
    it_behaves_like "a presence validator", Test::RestorationMessageValidatable, :message
    it_behaves_like "a length validator", Test::RestorationMessageValidatable, :message,
                    Helpers::TextGenerator.random_string(501)
  end
end
