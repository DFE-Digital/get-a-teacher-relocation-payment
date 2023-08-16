# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "pages#start"

  get "/ineligible", to: "pages#ineligible"
  get "/ineligible-salaried-course", to: "pages#ineligible_salaried_course"
  get "/closed", to: "pages#closed"

  namespace :applicants do
    resources :application_routes, only: %i[new create]
    resources :school_details, only: %i[new create edit]
    resources :contract_details, only: %i[new create edit]
    resources :contract_start_dates, only: %i[new create edit]
    resources :subjects, only: %i[new create edit]
    resources :teaching_details, only: %i[new create edit]
    resources :visas, only: %i[new create edit]
    resources :entry_dates, only: %i[new create edit]
    resources :personal_details, only: %i[new create edit]
    resources :employment_details, only: %i[new create edit]
    resources :salaried_course_details, only: %i[new create edit]
    resource :submission, only: %i[show]
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
  end

  scope module: :system_admin, path: "system-admin" do
    resources :applicants, only: %i[index show edit update]
    resources :users, except: %i[show]
    resource :settings, only: %i[edit update]
    get "/dashboard", to: "dashboard#show"
    resources "reports", only: %i[show index]
    get "/duplicates", to: "applicants#duplicates"
  end
end
