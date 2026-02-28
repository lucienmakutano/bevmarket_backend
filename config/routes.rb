Rails.application.routes.draw do
  # Authentication routes for devise
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
        namespace :v1 do
          resources :users
          resources :items
          resources :stock_items
          resources :expenses, only: [:index, :create, :show]
          resources :clients
          resources :sales, only: [:index, :create, :show]
          resources :establishments
          resources :employees
          resources :sale_points
          resources :purchases, only: [:index]
          resources :unemployed_users, only: [:index]
          resources :stock_movements, only: [:index]
          resources :sale_point_stock_items, only: [:index, :create]
        end
  end
end
