Plague::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'
  resource :session, only: :destroy

  resources :comments, only: [:index, :create]

  match '/posts',        to: 'posts#all'
  match '/posts/update', to: 'posts#update'
  root to: 'posts#title'

  match '*path', to: 'posts#show'
end
