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

  ## API ##
  mount_devise_token_auth_for 'User', at: "/api/v1/auth/users", controllers: {
    passwords:          'api/v1/auth/users/passwords',
    registrations:      'api/v1/auth/users/registrations',
    sessions:           'api/v1/auth/users/sessions',
    token_validations:  'api/v1/auth/users/token_validations'
  }

  #Sidekiq Web
  authenticate :admin_user, lambda { |u| u.present? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  #root to: "home#index"

  namespace :api do

    namespace :v1 do

      resources :laws, only: [:index, :show, :create, :update]

    end

  end

end
