# frozen_string_literal: true

namespace :test do
  desc "This is a test rake task"
  task task: :environment do
    puts "This is a test rake task"
  end
end
