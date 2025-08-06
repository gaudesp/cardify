Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  scope module: :public do
    authenticated :user do
      root to: 'sites#index', as: :authenticated_root
    end

    unauthenticated do
      root to: 'home#index', as: :unauthenticated_root
    end
  end

  root to: redirect { |_, req|
    req.env['warden'].authenticated?(:user) ? '/authenticated_root' : '/unauthenticated_root'
  }

  namespace :admin do
    scope "/:site_slug", as: :site do
      root to: 'home#index'
      get    "/edit", to: "sites#edit"
      patch  "/",     to: "sites#update"
      resources :pages, except: [:show], controller: 'pages' do
        member do
          patch :move_up
          patch :move_down
        end
      end
    end
  end

  scope module: :showcase do
    scope constraints: ->(req) { req.params[:site_slug] !~ /^admin$/ } do
      get "/:site_slug(/:page_slug)", to: "sites#show", as: :site
    end
  end
end
