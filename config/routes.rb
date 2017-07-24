require 'sidekiq/web'
Rails.application.routes.draw do
  
  devise_for :admin_users, path: :admin, controllers: {
    sessions: 'admin/devise/sessions',
    #registrations: 'admin/devise/registrations',
    #confirmations: 'admin/devise/confirmations',
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

  #Sidekiq Web
  authenticate :admin_user, lambda { |u| u.present? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  #root to: "home#index"

end
