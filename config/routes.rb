# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "pages#index"

  constraints(StepFlow) do
    get "/step/:name", to: "step#new", as: "step"
    post "/step/:name", to: "step#create"
    patch "/step/:name", to: "step#update"
  end

  get "/summary", to: "submission#summary", as: "summary"
  post "/summary", to: "submission#create", as: "new_submission"
  get "/submission", to: "submission#show", as: "submission"

  get "/ineligible", to: "pages#ineligible"
  get "/ineligible-salaried-course", to: "pages#ineligible_salaried_course"
  get "/closed", to: "pages#closed"
  get "/privacy", to: "pages#privacy"
  get "/sitemap", to: "pages#sitemap"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
  end

  scope module: :system_admin, path: "system-admin" do
    resources :applicants, only: %i[index show edit update] do
      collection do
        get :download_qa_csv
      end
    end

    resources :users, except: %i[show]
    resource :settings, only: %i[edit update]
    get "/dashboard", to: "dashboard#show"
    resources "reports", only: %i[show index]
    get "/duplicates", to: "applicants#duplicates"
  end
end
