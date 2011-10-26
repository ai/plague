Plague::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'
  resource :session, only: :destroy

  resources :comments, only: [:index, :create]

  match '/posts', to: 'posts#all'
  root to: 'posts#title'

  match '*path', to: 'posts#show'
end
