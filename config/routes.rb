# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "pages#start"

  get "/ineligible", to: "pages#ineligible"
  get "/ineligible-salaried-course", to: "pages#ineligible_salaried_course"

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

  # TODO: route constraint, only signed-in admins should be able to access
  scope module: :system_admin, path: "system-admin" do
    resources :applicants, only: %i[index show edit update]
    resources :users
    get "/dashboard", to: "dashboard#show"
  end
end
