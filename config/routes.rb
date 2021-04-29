Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :activities
      resources :redeem_requests, only: :create
      resources :users do
        member do
          put 'assign_role'
        end
      end

      post 'auth/login', to: "sessions#login"

      resources :projects do
        resources :users, controller: 'projects/users', only: :create do
          collection do
            put 'remove'
          end
        end
      end

      namespace :admin do
        resources :projects, only: :index
        resources :activities, only: :index do
          member do
            put 'approve'
            put 'reject'
          end
        end

        resources :redeem_requests, only: :index do
          member do
            put 'mark_complete'
          end
        end
      end
    end
  end
end
