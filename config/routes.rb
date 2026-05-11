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

  # Data Exports
  get "/data-exports", to: "data_exports#show", as: :data_exports
  get "/data-exports/history", to: "data_exports#download_history", as: :data_export_download_history
  get "/data-exports/:id", to: "data_exports#download", as: :data_export_download

  # Registration management
  resources :registrations, only: %i[show index], param: :reference do
    get "certificate", to: "certificates#show", as: :certificate
    get "communication_logs", to: "communication_logs#index", as: :communication_logs
    get "change_history", to: "change_history#index", as: :change_history
    get "payments", to: "payments#new", as: :add_payment_form
    post "payments", to: "payments#create", as: :add_payment
    get "payment_details", to: "payment_details#index", as: :payment_details
    patch "mark_as_legacy_bulk", to: "registrations#mark_as_legacy_bulk", as: :mark_as_legacy_bulk
    patch "mark_as_legacy_linear", to: "registrations#mark_as_legacy_linear", as: :mark_as_legacy_linear

    resources :record_refunds,
              only: %i[index new create],
              path: "record-refund",
              path_names: { new: ":payment_id/new" }

    resources :record_reversals,
              only: %i[index new create],
              path: "record-reversal",
              path_names: { new: ":payment_id/new" }

    resources :adjustment_types,
              only: %i[new create],
              path: "adjustment-type"

    resources :charge_adjustments,
              only: %i[new create],
              path: "charge-adjustment"

    resources :sites, only: :index do
      resources :exemptions, only: %i[index], controller: "site_exemptions"
      get :deregister, on: :member, to: "deregister_sites#new"
      post :deregister, on: :member, to: "deregister_sites#update"
      get :deregistrations, on: :member, to: "site_deregistrations#show"
    end

    get :linear, on: :collection, to: "registrations#linear", as: :linear
  end

  resources :deregistrations, only: :show, param: :reference

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

  resources :exemptions, only: :index do
    put :update, on: :collection
  end

  # Send edit invite email
  get "/send-edit-invite-emails/:id", to: "send_edit_invite_emails#new", as: :send_edit_invite_emails

  # Deregistration email exports
  resources :deregistration_email_exports, only: %i[new create]

  # Privacy policy
  get "/ad-privacy-policy", to: "ad_privacy_policy#show", as: :ad_privacy_policy

  # Charges management: bands, exemptions, buckets and charges
  resources :bands do
    get "destroy_confirmation", on: :member, to: "bands#destroy_confirmation", as: :destroy_confirmation
    get "cannot_destroy", on: :member, to: "bands#cannot_destroy", as: :cannot_destroy
  end
  resources :charges, only: %i[edit update]
  resources :buckets, only: %i[edit update]

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

  resources :analytics, only: %i[index]
  resources :analytics_incomplete_journeys, only: %i[index]
  resources :analytics_average_time_per_pages, only: %i[index]

  get "/testing/create_registration/:expiry_date",
      to: "testing#create_registration"

  # Editing: Back office
  scope "/:token", module: "waste_exemptions_engine" do
    resources :reason_for_change_forms,
              only: %i[new create],
              path: "reason-for-change",
              path_names: { new: "" }

    resources :operation_sites_forms,
              only: %i[new create],
              path: "operation_sites",
              path_names: { new: "" } do
                get ":site_id",
                    to: "operation_sites_forms#edit_site",
                    as: "edit_site",
                    on: :collection
              end

    resources :back_office_edit_forms,
              only: %i[new create],
              path: "edit",
              path_names: { new: "" } do
                get "main_people",
                    to: "back_office_edit_forms#edit_main_people",
                    as: "main_people",
                    on: :collection

                get "registration_number",
                    to: "back_office_edit_forms#edit_registration_number",
                    as: "registration_number",
                    on: :collection

                get "operator_name",
                    to: "back_office_edit_forms#edit_operator_name",
                    as: "operator_name",
                    on: :collection

                get "operator_postcode",
                    to: "back_office_edit_forms#edit_operator_postcode",
                    as: "operator_postcode",
                    on: :collection

                get "contact_name",
                    to: "back_office_edit_forms#edit_contact_name",
                    as: "contact_name",
                    on: :collection

                get "contact_position",
                    to: "back_office_edit_forms#edit_contact_position",
                    as: "contact_position",
                    on: :collection

                get "contact_phone",
                    to: "back_office_edit_forms#edit_contact_phone",
                    as: "contact_phone",
                    on: :collection

                get "contact_email",
                    to: "back_office_edit_forms#edit_contact_email",
                    as: "contact_email",
                    on: :collection

                get "contact_postcode",
                    to: "back_office_edit_forms#edit_contact_postcode",
                    as: "contact_postcode",
                    on: :collection

                get "on_a_farm",
                    to: "back_office_edit_forms#edit_on_a_farm",
                    as: "on_a_farm",
                    on: :collection

                get "is_a_farmer",
                    to: "back_office_edit_forms#edit_is_a_farmer",
                    as: "is_a_farmer",
                    on: :collection

                get "operation_sites",
                    to: "back_office_edit_forms#edit_operation_sites",
                    as: "operation_sites",
                    on: :collection

                get "site_grid_reference",
                    to: "back_office_edit_forms#edit_site_grid_reference",
                    as: "site_grid_reference",
                    on: :collection

                get "cancel",
                    to: "back_office_edit_forms#cancel",
                    as: "cancel",
                    on: :collection
              end

    resources :back_office_edit_complete_forms,
              only: %i[new create],
              path: "edit-complete",
              path_names: { new: "" }

    resources :confirm_back_office_edit_cancelled_forms,
              only: %i[new create],
              path: "confirm-edit-cancelled",
              path_names: { new: "" }

    resources :back_office_edit_cancelled_forms,
              only: %i[new create],
              path: "edit-cancelled",
              path_names: { new: "" }
  end

  # Engine
  mount WasteExemptionsEngine::Engine => "/"

  # Defra ruby features engine
  mount DefraRubyFeatures::Engine => "/features", as: "features_engine"

  # Defra ruby mocks (for govpay)
  mount DefraRubyMocks::Engine => "/bo/mocks"
end
# rubocop:enable Metrics/BlockLength
