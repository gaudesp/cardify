Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :admin do
    get "/", to: redirect("/")
    get "/:site_slug", to: "sites#index", as: :sites
    get "/:site_slug/edit", to: "sites#edit", as: :edit_site
    patch "/:site_slug", to: "sites#update", as: :site
  end
  
  root to: 'base#index'

  scope constraints: ->(req) { req.params[:site_slug] !~ /^admin$/ } do
    get "/:site_slug(/:page_slug)", to: "sites#show", as: :site
  end
end
