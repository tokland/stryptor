Rails.application.routes.draw do
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  
  resources :strips do
    collection { get :random }
    resources :transcripts, :only => [:show, :create]
  end
  
  root :to => "strips#index"
end
