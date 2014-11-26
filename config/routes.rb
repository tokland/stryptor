Rails.application.routes.draw do
  root :to => "application#index"
  
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'

  resources :strip_collections, :path => "" do  
    resources :strips, :only => [:index, :show], :path => "" do
      collection do
        get :random
        get :search
      end
      resources :transcripts, :only => [:show, :create]
    end
  end
end
