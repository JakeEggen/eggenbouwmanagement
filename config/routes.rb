Rails.application.routes.draw do
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "home#index"

  get "projects", to: "projects#index"
  
  get "lots", to: "lots#index"
  get "lots/kavel_a", to: "lots#kavel_a"
  get "lots/kavel_b", to: "lots#kavel_b"
  get "lots/kavel_c", to: "lots#kavel_c"

  get "contact", to: "contact#contact"
end
