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

  get "projecten", to: "projects#index", as: :projects
  get "projects", to: redirect("/projecten")

  get "kavels", to: "lots#index", as: :lots
  get "kavels/bouwgrond-europaweg-a", to: "lots#kavel_a", as: :lots_kavel_a
  get "kavels/bouwgrond-europaweg-b", to: "lots#kavel_b", as: :lots_kavel_b
  get "kavels/bouwgrond-europaweg-c", to: "lots#kavel_c", as: :lots_kavel_c
  get "lots", to: redirect("/kavels")
  get "lots/kavel_a", to: redirect("/kavels/bouwgrond-europaweg-a")
  get "lots/kavel_b", to: redirect("/kavels/bouwgrond-europaweg-b")
  get "lots/kavel_c", to: redirect("/kavels/bouwgrond-europaweg-c")

  get "contact", to: "contact#contact"
  post "contact", to: "contact#create"

  get "privacyverklaring", to: "pages#privacy", as: :privacy
end
