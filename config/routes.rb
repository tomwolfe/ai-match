Rails.application.routes.draw do
  resources :predictions
  get 'messages/index'

  get 'conversations/index'

  root 'welcome#index'
  get 'welcome/index'
  resources :rates
  get 'ratings' => "rates#ratings"
  get 'raters'=> "rates#raters"
  get 'mutual'=> "rates#mutual"
  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end
  resources :users do
    resources :rates
  end
  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout
  get "auth/failure", to: redirect('/')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
