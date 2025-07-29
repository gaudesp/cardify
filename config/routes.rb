Rails.application.routes.draw do
  devise_for :users

  root to: 'base#index'

  get "/:site_slug(/:page_slug)", to: "sites#show", as: :site
end
