Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "pages#start"

  get "/submitted", to: "pages#submitted"
  get "/ineligible", to: "pages#ineligible"

  namespace :applicants do
    resources :application_types, only: %i[new create]
    resources :school_details, only: %i[new create]
    resources :contract_details, only: %i[new create]
    resources :contract_start_dates, only: %i[new create]
    resources :subjects, only: %i[new create]
    resources :teaching_details, only: %i[new create]
    resources :visas, only: %i[new create]
    resources :entry_dates, only: %i[new create]
    resources :personal_details, only: %i[new create]
    resources :employment_details, only: %i[new create]
  end
end
