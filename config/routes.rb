Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'
  resources :rates
  resources :users do
    get 'ratings'
    get 'raters'
    get 'mutual'
    resources :rates
  end
  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout
  get "auth/failure", to: redirect('/')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
