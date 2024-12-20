Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
  
 # Posters API Endpoints
  get "/api/v1/posters", to: "api/v1/posters#index"
  get "/api/v1/posters/:id", to: "api/v1/posters#show"
  post "/api/v1/posters", to: "api/v1/posters#create"
  patch "/api/v1/posters/:id", to: "api/v1/posters#update"
  delete "/api/v1/posters/:id", to: "api/v1/posters#destroy" # Delete a poster
end
