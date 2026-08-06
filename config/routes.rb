Rails.application.routes.draw do
  root "characters#index"
  get "em-breve/:feature", to: "pages#coming_soon", as: :coming_soon
  resource :session
  resources :passwords, param: :token
  resources :characters, only: %i[ index show create ] do
    collection do
      delete "wizard", to: "characters/wizard#destroy", as: :wizard
      get "wizard/:step", to: "characters/wizard#show", as: :wizard_step
      patch "wizard/:step", to: "characters/wizard#update"
    end
    member do
      patch :hit_points
      patch :spell_slot
      get :edit_spells
      patch :spells, action: :update_spells
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
