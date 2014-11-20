Rails.application.routes.draw do
  root :to => "strips#index"
  
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'

  resources :strip_collections, :path => "" do  
    resources :strips, :path => "" do
      collection { get :random }
      resources :transcripts, :only => [:show, :create]
    end
  end
end
