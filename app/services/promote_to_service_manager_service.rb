# frozen_string_literal: true

class PromoteToServiceManagerService < WasteExemptionsEngine::BaseService
  def initialize
    @logger = Logger.new($stdout)
    super
  end

  def run(email)
    return log_error("Email address is required") if email.blank?

    user = User.find_by(email: email)
    return log_error("No user found with email #{email}") if user.nil?
    return log_error("User #{email} is not active") unless user.active?
    return log_message("User #{email} is already a service manager") if user.role_is?(:service_manager)

    promote_user(user)
  rescue StandardError => e
    log_error("An unexpected error occurred while updating the user role: #{e.message}")
  end

  private

  def promote_user(user)
    old_role = user.role
    user.change_role("service_manager")

    if user.save
      log_message("Successfully promoted user #{user.email} from #{old_role} to service_manager")
      true
    else
      log_error("Failed to update user role: #{user.errors.full_messages.join(', ')}")
    end
  end

  def log_error(message)
    @logger.info "Error: #{message}"
    false
  end

  def log_message(message)
    @logger.info message
    false
  end
end
