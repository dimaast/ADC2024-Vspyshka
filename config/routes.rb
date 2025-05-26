Rails.application.routes.draw do
  get "subscription/toggle"
  get "response/toggle"
  get "favourite/toggle"

  resources :profiles do
    collection do
      get "/by_tag/:tag", to: "events#by_tag", as: "tagged"
    end
  end
  resources :email_subscriptions, only: [ :create ]

  devise_for :users

  resources :communities, except: [ :create, :destroy ]

  resources :comments

  resources :events do
    resources :comments

    collection do
      get "archive"
      # get "/by_tag/:tag", to: "events#by_tag", as: "tagged"
      get :by_tag
    end
  end

  resources :meets do
    resources :comments

    collection do
      get "/by_tag/:tag", to: "events#by_tag", as: "tagged"
    end
  end

  namespace :admin do
    resources :programs
    resources :faculties
    resources :communities, except: [ :show, :edit ]
    resources :email_subscriptions, only: [ :index, :show, :destroy ]
  end

  namespace :api, format: "json" do
    namespace :v1 do
      resources :events, only: [ :index, :show, :create, :update, :destroy ]
      resources :meets, only: [ :index, :show, :create, :update, :destroy ]
      resources :communities, only: [ :index, :show ]
      resources :profiles, only: [ :index, :show ]
      resources :users, only: [ :index, :show ]

      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
        post "sign_out", to: "sessions#destroy"
      end
    end
  end

  # :index, :show, :edit, :update, :create, :destroy
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  get "welcome/index"
  get "welcome/about"

  root "welcome#index"
end
