Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users do
        member do
          put 'assign_role'
        end
      end

      resources :users
      resources :projects

      post 'auth/login', to: "sessions#login"
    end
  end
end
