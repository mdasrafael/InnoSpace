Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for  :users,
              :path => '',
              :path_names => {:sign_in => 'login', :sign_out => 'logout', :edit => 'profile'},
              :controllers => {
                                :omniauth_callbacks => 'omniauth_callbacks',
                                :registrations => 'registrations'
                              }
  resources :users do
    get 'users', :to => 'pages#main', :as => :user_root
  end

  resources :users, only: [:show]
  resources :spaces
  resources :photos
  resources :spaces do
    resources :bookings, only: [:create,:update]
  end

  resources :spaces do
    resources :reviews, only: [:create, :destroy]
  end

  resources :conversations, only: [:index,:create] do
    resources :messages, only: [:index,:create]
  end

  get '/preload' => 'bookings#preload'
  get '/preview' => 'bookings#preview'

  get '/your_bookings' => 'bookings#your_bookings'
  get '/your_events' => 'bookings#your_events'

  post '/notify' => 'bookings#notify'
  post '/your_events' => 'bookings#your_events'

  get '/search' => 'pages#search'
  get '/main' => 'pages#main'

  post '/pay' => 'charge#pay'

  get '/cancel_booking' => 'bookings#cancel'
  put '/confirm_booking' => 'bookings#confirm'
  put '/pay_booking' => 'bookings#pay'

  get '/' => 'landingpage#index'
end
