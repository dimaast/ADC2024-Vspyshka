Rails.application.routes.draw do
  get "reports/new"
  get "reports/create"
  get "settings/index"
  get "subscription/toggle"
  get "response/toggle"
  post "favourite/toggle", to: "favourite#toggle", as: "favourite_toggle"

  resources :profiles do
    member do
      get :subscribers
    end
  end
  resources :email_subscriptions, only: [ :create ]

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :communities, except: [ :create, :destroy ] do
    collection do
      get :by_tag
    end
    member do
      get :subscribers
    end
  end

  resources :comments

  resources :events do
    resources :comments
    resources :reports, only: [ :new, :create ]

    collection do
      get "archive"
      # get "/by_tag/:tag", to: "events#by_tag", as: "tagged"
      get :by_tag
      get :places
    end
    member do
      get :participants
    end
  end

  resources :reports, only: [ :new, :create ]

  resources :meets do
    resources :comments
    resources :meet_participants, only: [:index], path: 'participants'

    collection do
      get "/by_tag/:tag", to: "meets#by_tag", as: "tagged"
    end
  end

  # уведы !!!
  # resources :notifications, only: [] do
  #   collection do
  #     post :mark_all_read
  #   end
  # end

  resource :support_messages, only: [ :create ]

  # Маршруты для уведомлений
  resources :notifications, only: [] do
    member do
      patch :mark_read
      get :redirect
    end
    collection do
      post :mark_all_read
    end
  end

  namespace :admin do
    root 'dashboard#index'
    get "reports/index"
    get "reports/show"
    get "reports/update"
    resources :programs
    resources :faculties
    resources :communities, except: [ :show, :edit ]
    resources :email_subscriptions, only: [ :index, :show, :destroy ]
    resources :reports, only: [ :index, :show, :update ]
    resources :users, only: [ :index ]
  end

  namespace :api, format: "json" do
    namespace :v1 do
      resources :events, only: [ :index, :show, :create, :update, :destroy ] do
        collection do
          get :places
        end
      end
      resources :meets, only: [ :index, :show, :create, :update, :destroy ]
      resources :communities, only: [ :index, :show ] do
        member do
          post :subscribe
          delete :unsubscribe
          get :subscribers
        end
      end
      resources :profiles, only: [ :index, :show ]
      resources :users, only: [ :index, :show ]
      
      # Эндпоинты для тегов и категорий
      get "tags", to: "tags#index"
      get "categories", to: "tags#categories"
      
      # Эндпоинт для загрузки файлов
      post "uploads", to: "uploads#create"
      
      # Эндпоинты для избранного
      resources :favourites, only: [:index, :create, :destroy] do
        collection do
          post :toggle
        end
      end

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

  # Маршруты для поиска
  get "search", to: "search#index", as: "search"
  get "search/autocomplete", to: "search#autocomplete", as: "search_autocomplete"

  # Страница правила сервиса
  get "rules", to: "welcome#rules", as: "rules"

  # Страница лицензиннного соглашения
  get "license_agreement", to: "welcome#license_agreement", as: "license_agreement"

  # Страница о команде
  get "team", to: "welcome#team", as: "team"

   # Страница настроек
   get "/settings", to: "settings#index", as: :settings

  # Шаг выбора интересов после регистрации
  get "interests/choose", to: "interests#choose", as: :choose_interests
  post "interests/choose", to: "interests#save", as: :save_interests

  post 'like/toggle', to: 'like#toggle', as: :like_toggle

  root "welcome#index"

  # Обработка всех несуществующих маршрутов (404)
  match '*unmatched', to: 'errors#not_found', via: :all
end
