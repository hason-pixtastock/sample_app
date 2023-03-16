Rails.application.routes.draw do
  
  get 'sessions/new'
  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope "(:locale)", locale: /en|vi/ do
    root 'static_pages#home'
    get 'static_pages/home'
    get 'static_pages/help'
    get 'static_pages/about'
    get 'static_pages/contact'
    get '/signup', to: 'users#new'
    post '/signup', to: 'users#create'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    resources :users 
    resources :password_resets, only:[:new, :create, :edit, :update]
    resources :microposts, only: [:create, :destroy]
  end
end
