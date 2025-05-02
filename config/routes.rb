Rails.application.routes.draw do
<<<<<<< Updated upstream
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
=======
  # User login
  post "/login", to: "users#login"

  # RESTful routes
  resources :users, only: [ :create, :index, :show, :update, :destroy ]
  resources :roles, only: [ :create, :index, :show, :update, :destroy ]
  resources :events, only: [ :create, :index, :show, :update, :destroy ]
  resources :categories, only: [ :create, :index, :show, :update, :destroy ]
  resources :event_registrations, only: [ :create, :index, :show, :update, :destroy ]
  resources :discount_codes, only: [ :create, :index, :show, :update, :destroy ] do
    get "event_discounts/:event_id", to: "discount_codes#event_discounts", as: "event_discounts"
  end

  # Payments
  resources :payments, only: [ :index, :show, :create, :update ] do
    collection do
      post "success"
      post "failure"
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
>>>>>>> Stashed changes
end
