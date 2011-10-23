Plague::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'
  resource :session, only: :destroy

  resources :comments, only: [:index, :create]

  root to: 'posts#title'

  match '*path', to: 'posts#show'
end
