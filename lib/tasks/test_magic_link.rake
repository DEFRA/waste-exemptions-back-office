# frozen_string_literal: true

namespace :test do
  desc "Generate and print to console a renewal/deregistration link for a specified registration"
  task :magic_link, %i[reference] => :environment do |_t, args|

    @registration = WasteExemptionsEngine::Registration.find_by(reference: args[:reference])
    if @registration.nil?
      puts "Failed to find registration with reference \"#{args[:reference]}\""
      next
    end

    puts magic_link_url
  end

  def magic_link_url
    Rails.configuration.front_office_url +
      WasteExemptionsEngine::Engine.routes.url_helpers.renew_path(token: magic_link_token)
  end

  def magic_link_token
    @registration.regenerate_renew_token if @registration.renew_token.nil?
    @registration.renew_token
  end
end
