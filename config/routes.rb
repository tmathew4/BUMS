  #GoogleAuthExample::Application.routes.draw do

#end
  
Rails.application.routes.draw do
 get 'sessions/create'
 get 'sessions/destroy'

  #get 'home/show'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  #resource :home, only: [:show]

  #root to: "home#show"


  root 'events#index'
  resources :events do
      resources :attendees
      #collection {get 'search'}
  end
  #resources :users do
    # Creates users/login(.:format)  users#login
  #  collection {get 'login'}
  #end
  

end