Rails.application.routes.draw do
  root 'welcome#index'
  
  resources :users
  match "/auth/:provider/callback" => "sessions#create", via: :post
  match "/signout" => "sessions#destroy", :as => :signout, via: :delete

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
