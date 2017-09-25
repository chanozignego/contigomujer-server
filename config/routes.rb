require 'sidekiq/web'
Rails.application.routes.draw do
  
  devise_for :admin_users, path: :admin, controllers: {
    sessions: 'admin/devise/sessions',
    registrations: 'admin/devise/registrations',
    confirmations: 'admin/devise/confirmations',
    passwords: 'admin/devise/passwords',
    unlocks: 'admin/devise/unlocks'
  }

  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource

      #Mass Assigment routes
      namespace dashboard_resource do
        post :mass_assignment 
      end

    end

    resources :admin_users, only: [] do
      get :change_password
      put :update_password
    end

    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end

  # API ##
  mount_devise_token_auth_for 'User', at: "/api/v1/auth/users", controllers: {
    passwords:          'api/v1/auth/users/passwords',
    registrations:      'api/v1/auth/users/registrations',
    sessions:           'api/v1/auth/users/sessions',
    token_validations:  'api/v1/auth/users/token_validations'
  }

  # API ##
  mount_devise_token_auth_for 'Auxiliary', at: "/api/v1/auth/auxiliaries", controllers: {
    passwords:          'api/v1/auth/auxiliaries/passwords',
    registrations:      'api/v1/auth/auxiliaries/registrations',
    sessions:           'api/v1/auth/auxiliaries/sessions',
    token_validations:  'api/v1/auth/auxiliaries/token_validations'
  }

  #root to: "home#index"

  namespace :api do

    namespace :v1 do

      resources :laws, only: [:index, :show, :create, :update]

      resources :infos, only: [:index, :show, :create, :update]

      resources :towns, only: [:index]

      resources :assistances, only: [:index, :show, :create, :update] do
        member do
          put :cancel
          put :accept
        end
      end

      resources :messages, only: [:show] do
        member do
          put :read
          put :view
        end
      end

      resources :users, only: [:show, :create, :update] do
        member do
          get :messages
          put :mark_messages_as_viewed
        end
      end

      resources :auxiliaries, only: [:show, :update] do
        member do
          get :messages
          put :mark_messages_as_viewed
        end
      end

    end

  end

  #Sidekiq Web
  authenticate :admin_user, lambda { |u| u.present? } do
    mount Sidekiq::Web => '/sidekiq'
  end


end
