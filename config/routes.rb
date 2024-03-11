# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root "dashboards#index"

  # User management
  devise_for :users,
             controllers: { invitations: "user_invitations", sessions: "sessions" },
             path: "/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  get "/users", to: "users#index", as: :users
  get "/users/all", to: "users#all", as: :all_users

  get "/users/role/:id", to: "user_roles#edit", as: :user_role_form
  post "/users/role/:id", to: "user_roles#update", as: :user_role

  get "/users/activate/:id", to: "user_activations#activate_form", as: :activate_user_form
  get "/users/deactivate/:id", to: "user_activations#deactivate_form", as: :deactivate_user_form
  post "/users/activate/:id", to: "user_activations#activate", as: :activate_user
  post "/users/deactivate/:id", to: "user_activations#deactivate", as: :deactivate_user

  # Confirmation Letter
  get "/confirmation-letter/:id", to: "confirmation_letter#show", as: :confirmation_letter

  # Renewal Letter
  get "/renewal-letter/:id", to: "renewal_letter#show", as: :renewal_letter

  # Bulk Exports
  get "/data-exports", to: "bulk_exports#show", as: :bulk_exports

  # Registration management
  resources :registrations, only: :show, param: :reference do
    get "certificate", to: "certificates#show", as: :certificate
    get "communication_logs", to: "communication_logs#index", as: :communication_logs
  end

  get "/registrations/:id/modify_expiry_date", to: "modify_expiry_date#new", as: :modify_expiry_date_form
  post "/registrations/:id/modify_expiry_date", to: "modify_expiry_date#update", as: :modify_expiry_date

  get "/registrations/:id/reset_transient_registrations", to: "reset_transient_registrations#new",
                                                          as: :reset_transient_registrations_form
  post "/registrations/:id/reset_transient_registrations", to: "reset_transient_registrations#update",
                                                           as: :reset_transient_registrations

  resources :new_registrations, only: :show, path: "/new-registrations"

  # Deregister Registrations
  get "/registrations/deregister/:id", to: "deregister_registrations#new", as: :deregister_registrations_form
  post "/registrations/deregister/:id", to: "deregister_registrations#update", as: :deregister_registrations

  # Deregister Exemptions
  get "/registration-exemptions/deregister/:id", to: "deregister_exemptions#new", as: :deregister_exemptions_form
  post "/registration-exemptions/deregister/:id", to: "deregister_exemptions#update", as: :deregister_exemptions

  # Send edit invite email
  get "/send-edit-invite-emails/:id", to: "send_edit_invite_emails#new", as: :send_edit_invite_emails

  # Deregistration email exports
  resources :deregistration_email_exports, only: %i[new create]

  # Privacy policy
  get "/ad-privacy-policy", to: "ad_privacy_policy#show", as: :ad_privacy_policy

  # Override renew path
  get "/renew/:reference",
      to: "renews#new",
      as: "renew"

  get "/resend-confirmation-email/:reference",
      to: "resend_confirmation_email#new",
      as: "resend_confirmation_email"

  get "/resend-renewal-email/:reference",
      to: "resend_renewal_email#new",
      as: "resend_renewal_email"

  get "/resend-confirmation-letter/:reference",
      to: "resend_confirmation_letter#new",
      as: "confirm_resend_confirmation_letter"

  post "/resend-confirmation-letter/:reference",
       to: "resend_confirmation_letter#create",
       as: "resend_confirmation_letter"

  get "/resend-renewal-letter/:reference",
      to: "resend_renewal_letter#new",
      as: "confirm_resend_renewal_letter"

  post "/resend-renewal-letter/:reference",
       to: "resend_renewal_letter#create",
       as: "resend_renewal_letter"

  patch "/companies-house-details/:reference",
        to: "refresh_companies_house_name#update_companies_house_details",
        as: :refresh_companies_house_name

  get "/reports/quarterly_stats",
      to: "quarterly_stats#show",
      as: "quarterly_stats"

  resources :analytics,
            only: %i[index]

  get "/testing/create_registration/:expiry_date",
      to: "testing#create_registration"

  # Engine
  mount WasteExemptionsEngine::Engine => "/"

  # Defra ruby features engine
  mount DefraRubyFeatures::Engine => "/features", as: "features_engine"
end
# rubocop:enable Metrics/BlockLength
