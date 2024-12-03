# frozen_string_literal: true

class OrderPresenter < BasePresenter
  def exemption_codes
    exemptions.map(&:code).sort.join(",")
  end
end
