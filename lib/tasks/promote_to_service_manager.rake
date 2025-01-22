# frozen_string_literal: true

namespace :user do
  desc "Promote a back office user to service manager role by providing their email"
  task :promote_to_service_manager, [:email] => :environment do |_, args|
    PromoteToServiceManagerService.run(args[:email])
  end
end
