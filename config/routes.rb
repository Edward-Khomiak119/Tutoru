Rails.application.routes.draw do
  resources :payment_sources
  resources :chats
  resources :messages

  resources :offers do
    member do
      get :accept
    end
  end
  
  resources :help_requests do
    member do
      get :finish, :accept
    end
  end



  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get '/home' => 'application#home'
  get '/account' => 'application#account'
  get '/current_request' => 'application#current_request'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  authenticated :user do
    root to: "application#home"
  end

  root to: "application#landing"
end