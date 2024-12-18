Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # API namespace
  namespace :api do
    namespace :v1 do
      resources :posters, only: [:show]
    end
  end
end
